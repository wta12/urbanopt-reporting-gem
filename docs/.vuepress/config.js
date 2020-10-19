const path = require('path');

module.exports = {
  base: '/urbanopt-reporting-gem/',
  themeConfig: {
    navbar: false,
    sidebar: [
      "/",
      {
        title: "Schemas",
        children: [
          "/schemas/scenario-schema.md"
        ]
      }
    ]
  },
  chainWebpack: config => {
    config.module
      .rule('json')
        .test(/\.json$/)
        .use(path.join(__dirname, 'json-schema-deref-loader.js'))
          .loader(path.join(__dirname, 'json-schema-deref-loader.js'))
          .end()
  },
};
