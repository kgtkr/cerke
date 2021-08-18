module.exports = {
  stories: ["../src/**/*.stories.js"],
  addons: [
    "@storybook/addon-essentials",
    "@storybook/addon-links",
    "@storybook/addon-postcss",
  ],
  core: {
    builder: "webpack5",
  },
};
