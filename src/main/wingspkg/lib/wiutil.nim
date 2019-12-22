from sequtils import toSeq
from strlib import replace, seqCharToString
from strutils import join, split
import log
import sets
import tables
import ./winterface, ./tconfig, ./tconstant, ./templating, ./templatable
import ../util/filename, ../util/header, ../util/config
import ../lang/defaults

proc addImport(iwings: var IWings, newImport: string, importLang: string): void =
    if not iwings.imports.hasKey(importLang):
        iwings.imports.add(importLang, initHashSet[string]())
    iwings.imports[importLang].incl(newImport)

proc fulfillDependency(
    iwings: var IWings,
    dependency: string,
    imports: Table[string, string],
    langConfig: Table[string, TConfig] = initTable[string, TConfig](),
): bool =
    ## Fulfill the required dependency (after dependant file is generated).
    if not iwings.dependencies.contains(dependency):
        result = false
    else:
        for importType in imports.keys:
            if langConfig[importType].importPath.pathType == ImportPathType.Never:
                continue
            var ipString: string = imports[importType]
            if langConfig[importType].importPath.format.len() > 0:
                var i: int = 1
                var replaceMap: Table[string, string] = initTable[string, string]()
                var words: seq[string] = ipString.split(
                    langConfig[importType].importPath.separator
                )
                for w in words:
                    var word: string = w
                    var s: string = wrap($(words.len() - i))
                    if word == "." or word == "..":
                        s &= ":"
                        word = ""
                    replaceMap.add(s, word)
                    inc(i)
                words.setLen(words.len() - langConfig[importType].importPath.level)
                replaceMap.add(
                    wrap(TK_IMPORT),
                    words.join($langConfig[importType].importPath.separator),
                )
                ipString = seqCharToString(
                    toSeq(
                        langConfig[importType].importPath.format.items
                    ).replace(replaceMap)
                )
            iwings.addImport(ipString, importType)

        var location: int = iwings.dependencies.find(dependency)
        iwings.dependencies.delete(location)
        result = true

proc dependencyGraph*(
    allWings: var Table[string, IWings],
    config: Config,
): Table[string, Table[string, string]] =
    ## Generate and fulfill all dependencies in its intended succession.
    var noDeps: seq[string] = newSeq[string](0)
    var filenameToObj: Table[string, IWings] = initTable[string, IWings]()
    var reverseDependencyTable: Table[string, seq[string]] =
        initTable[string, seq[string]]()
    result = initTable[string, Table[string, string]]()

    var index = 0;
    for wings in allWings.values:
        filenameToObj[wings.filename] = wings
        if wings.dependencies.len() == 0:
            noDeps.add(wings.filename)

        for dependency in wings.dependencies:
            if not reverseDependencyTable.hasKey(dependency):
                reverseDependencyTable[dependency] = newSeq[string](0)
            reverseDependencyTable[dependency].add(wings.filename)

        index += 1

    # TODO: Multithread this
    while noDeps.len() > 0:
        var wings: IWings = filenameToObj[noDeps.pop()]
        var name: string = wings.filename
        LOG(DEBUG, "Generating files from " & name & "...")

        # discard tconfig.parse("examples/input/templates/ts.json")

        if not (config.skipImport and wings.imported):
            var files: Table[string, string] = initTable[string, string]()
            for lang in DEFAULT_CONFIGS.keys:
                if wings.filepath.hasKey(lang):
                    files.add(
                        outputFilename(
                            wings.filename,
                            wings.filepath[lang],
                            DEFAULT_CONFIGS[lang],
                        ),
                        genFile(
                            wingsToTemplatable(
                                wings,
                                DEFAULT_CONFIGS[lang]
                            ),
                            DEFAULT_CONFIGS[lang],
                            wings.wingsType
                        )
                    )
            result.add(name, files)

        if reverseDependencyTable.hasKey(name):
            for dependant in reverseDependencyTable[name]:
                var obj = filenameToObj[dependant]
                var importFilenames: Table[string, string] = initTable[string, string]()
                for lang in DEFAULT_CONFIGS.keys:
                    if wings.filepath.hasKey(lang):
                        let ip: string = importFilename(
                            wings.filename,
                            wings.filepath[lang],
                            obj.filename,
                            obj.filepath[lang],
                            DEFAULT_CONFIGS[lang],
                        )

                        if ip.len() > 0:
                            importFilenames.add(lang,ip)

                let fulfillDep: bool = obj.fulfillDependency(name, importFilenames, DEFAULT_CONFIGS)
                if not fulfillDep:
                    LOG(
                        ERROR,
                        "Something went wrong when fulfilling a dependency of" &
                        name &
                        "for " &
                        obj.name,
                    )
                else:
                    allWings[obj.filename] = obj

            reverseDependencyTable.del(name)

        allWings.del(wings.filename)

    if allWings.len() > 0:
        let next = dependencyGraph(allWings, config)

        for k in next.keys:
            result.add(k, next[k])
