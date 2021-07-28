// require("dotenv").config();

const bsconfig = require("./bsconfig.json");
const fs = require("fs");

const transpileModules = ["rescript"].concat(bsconfig["bs-dependencies"]);
const withTM = require("next-transpile-modules")(transpileModules);

// Using MongoDB in NexJS API requests can trigger errors indicating the following modules are not found.
// This only seems to impact:
// [A] The server side part of the build, client side part of build seems to work fine.
// [B] Local builds, builds on Vercal seem to work fine.
// Marking the modules as fallbacks with value false seems to resolve the problem.
const mongoDBFallback = {
  "bson-ext": false,
  kerberos: false,
  snappy: false,
  aws4: false,
  "mongodb-client-encryption": false,
};

const config = {
  target: "serverless",
  pageExtensions: ["jsx", "js"],
  env: {
    ENV: process.env.NODE_ENV,
  },
  webpack: (config, options) => {
    const { isServer } = options;

    if (isServer) {
      config.resolve.fallback = {
        ...config.resolve.fallback,
        ...mongoDBFallback,
      };
    } else {
      // This was included in the rescript nextjs template,
      // but does not seem to be needed here.
      // config.resolve.fallback = {
      //   fs: false,
      //   path: false,
      // };
    }

    // We need this additional rule to make sure that mjs files are
    // correctly detected within our src/ folder
    config.module.rules.push({
      test: /\.m?js$/,
      use: options.defaultLoaders.babel,
      exclude: /node_modules/,
      type: "javascript/auto",
      resolve: {
        fullySpecified: false,
      },
    });

    return config;
  },
};

module.exports = withTM(config);
