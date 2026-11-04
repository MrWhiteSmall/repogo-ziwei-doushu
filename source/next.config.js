/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',
  images: { unoptimized: true },
  transpilePackages: ['lunar-javascript'],
};

module.exports = nextConfig;
