import PackageDescription

let package = Package(
    name: "Places",
    dependencies: [
        .Package(url:"https://github.com/GeminiSolutions/DataStore", majorVersion: 0)
    ]
)
