module.exports = {
    entry: "./entry.coffee",
    output: {
        path: __dirname,
        filename: "livewiki.js"
    },
    module: {
        loaders: [
            { test: /\.coffee$/, loader: "coffee-loader" },
            { test: /\.(coffee\.md|litcoffee)$/, loader: "coffee-loader?literate" }
        ]
    }
};
