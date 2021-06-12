const HtmlWebpackPlugin = require("html-webpack-plugin");
const { CleanWebpackPlugin } = require("clean-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");
const path = require("path");
const CompressionPlugin = require("compression-webpack-plugin");
const WasmPackPlugin = require("@wasm-tool/wasm-pack-plugin");
const webpack = require("webpack");

function match(x, map) {
  return map[x]();
}

module.exports = (env, argv) => {
  process.env["WASM_BINDGEN_WEAKREF"] = "1";

  return {
    entry: {
      main: ["./src/app.ts"],
    },
    output: {
      filename: "[name].[chunkhash].js",
      path: __dirname + "/public-dist",
      publicPath: "/",
    },
    resolve: {
      extensions: [".ts", ".tsx", ".js", ".wasm"],
      alias: {
        "@styles": path.resolve(__dirname, "styles"),
      },
    },
    plugins: [
      new HtmlWebpackPlugin({
        template: "index.html",
        filename: "index.html",
      }),
      new CopyWebpackPlugin({
        patterns: [
          {
            from: "public",
            to: "",
          },
        ],
      }),
      new CleanWebpackPlugin({ cleanStaleWebpackAssets: false }),
      ...match(argv.mode, {
        production: () => [new CompressionPlugin({})],
        development: () => [],
      }),
      new WasmPackPlugin({
        crateDirectory: path.resolve(__dirname, "lib-rs"),
      }),
      new webpack.LoaderOptionsPlugin({
        options: {
          exprimnet: {
            asyncWebAssembly: true,
          },
        },
      }),
    ],
    module: {
      rules: [
        { test: /\.tsx?$/, loader: "ts-loader" },
        {
          test: /\.html?$/,
          loader: "html-loader",
        },
        {
          test: /\.s?css$/,
          use: [
            {
              loader: "style-loader",
            },
            {
              loader: "css-loader",
              options: {
                url: false,
                modules: true,
              },
            },
            {
              loader: "sass-loader",
            },
          ],
        },
        {
          test: /\.wasm$/,
          type: "webassembly/async",
        },
      ],
    },
    devtool: match(argv.mode, {
      production: () => false,
      development: () => "source-map",
    }),
    optimization: {
      splitChunks: {
        name: "vendor",
        chunks: "initial",
      },
    },
    devServer: {
      contentBase: path.join(__dirname, "public"),
      port: process.env["PORT"] || 4000,
      historyApiFallback: true,
    },
    experiments: {
      asyncWebAssembly: true,
      topLevelAwait: true,
    },
  };
};
