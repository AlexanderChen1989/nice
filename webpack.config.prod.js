const webpack = require('webpack')
const ExtractTextPlugin = require('extract-text-webpack-plugin')

const node_modules = __dirname+'/node_modules'
const src = __dirname + '/web/static'
const dist = __dirname + '/priv/static'

const GLOBALS = {
  'process.env.NODE_ENV': '"production"',
  __DEV__: false
}

module.exports = {
	entry: [
		src+'/app.jsx'
	],
	output: {
		path: dist,
		filename: 'js/app.js'
	},
	module: {
		loaders: [
			{
				test: /\.(js|jsx)$/,
				exclude: /node_modules/,
				loader: 'babel',
				query: {
					presets: ['es2015', 'react', 'stage-1'],
					plugins: [
						["import", {"libraryName": "antd", "style": true}]
					]
				}
			},
			{
				test: /\.less$/,
				loader: ExtractTextPlugin.extract(
					'css!less'
				)
			},
			{
				test: /\.(ttf|eot|svg|woff|woff2)(\?[a-z0-9=&.]+)?$/,
				loader : 'file?name=./font/[hash].[ext]'
			}
		]
	},
	plugins: [
    new webpack.ProvidePlugin({
        jQuery: 'jquery',
        $: 'jquery',
        jquery: 'jquery'
    }),
	 	new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.DefinePlugin(GLOBALS), // Tells React to build in prod mode. https://facebook.github.io/react/downloads.html
		new ExtractTextPlugin('css/app.css'),
    new webpack.optimize.DedupePlugin(),
    new webpack.optimize.UglifyJsPlugin()
	],
	resolve: {
		extensions: ['', '.jsx', '.js', '.less']
	}
}
