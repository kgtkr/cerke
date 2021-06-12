const webpack = require("webpack");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const { CleanWebpackPlugin } = require("clean-webpack-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");
const path = require("path");
const CompressionPlugin = require("compression-webpack-plugin");
const FaviconsWebpackPlugin = require("favicons-webpack-plugin");

function match(x, map) {
  return map[x]();
}

module.exports = (env, argv) => {
  return {
    entry: {
      main: ["./lib/es6/src/Index.bs.js"],
    },
    output: {
      filename: "[name].[chunkhash].js",
      path: __dirname + "/public-dist",
      publicPath: "/",
    },
    resolve: {
      extensions: [".js"],
      alias: {
        "@styles": path.resolve(__dirname, "styles"),
      },
    },
    plugins: [
      new HtmlWebpackPlugin({
        template: "index.html",
        filename: "index.html",
      }),
      new FaviconsWebpackPlugin({
        logo: "./icon.svg",
        cache: true,
        prefix: "assets/",
        inject: true,
        mode: "webapp",
        devMode: "webapp",
        favicons: {
          appName: "cerke",
          appDescription: "cerke online",
          background: "#006400",
          theme_color: "#00ff00",
          icons: {},
        },
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
        production: () => [
          new CompressionPlugin({ minRatio: Number.MAX_SAFE_INTEGER }),
        ],
        development: () => [],
      }),
    ],
    module: {
      rules: [
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
  };
};
