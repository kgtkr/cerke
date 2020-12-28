const path = require("path");

module.exports = async ({ config, mode }) => {
  config.module.rules.push({
    test: /\.scss$/,
    use: [
      {
        loader: "style-loader",
      },
      {
        loader: "css-loader?modules",
      },
      {
        loader: "sass-loader",
      },
    ],
  });

  config.resolve.alias = {
    "@styles": path.resolve(__dirname, "../styles"),
  };

  return config;
};
