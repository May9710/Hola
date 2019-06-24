const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');
const web3 = new Web3(ganache.provider());

const compiledLogin = require('../ethereum/build/AnalysisLogin.json');
const compiledAnalysis = require('../ethereum/build/Analysis.json');

let accounts;
let login;
let analysisAddress;
let analysis;
//Create instance 
beforeEach(async () => {
	accounts = await web3.eth.getAccounts();

	login = await new web3.eth.Contract(JSON.parse(compiledLogin.interface))
		.deploy({ data: compiledLogin.bytecode })
		.send({ from: accounts[0], gas: '1000000'});
	//I don't specify a minimum amount (In Campaign => minimumContribution!)
	await login.methods.makeAnalysis().send({
		from: accounts[0],
		gas: '1000000'
	});

	[analysisAddress] = await login.methods.getClients().call();
	analysis = await new web3.eth.Contract(
		JSON.parse(compiledAnalysis.interface),
		analysisAddress //Address deployed 
	);
});

//Tests

// 1 . Login and analytic were successfully deployed
describe('Analysis', () => {
	it('deploys a login and an analysis', () => {
		assert.ok(login.options.address);
		assert.ok(analysis.options.address);
	});
});









