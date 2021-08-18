const path = require("path");

module.exports = async ({ config, mode }) => {
  config.module.rules.push({
    test: /\.scss$/,
    use: [
      {
        loader: "style-loader",
      },
      {
        loader: "css-loader",
        options: {
          modules: true,
        },
      },
      {
        loader: "sass-loader",
      },
    ],
  });
  return config;
};
