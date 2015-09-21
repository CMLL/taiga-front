var utils = require('../../utils');

var chai = require('chai');
var chaiAsPromised = require('chai-as-promised');

chai.use(chaiAsPromised);
var expect = chai.expect;

describe('user profile - likes', function() {
    describe('current user', function() {
        before(async function(){
            browser.get('http://localhost:9001/profile');

            await utils.common.waitLoader();

            $$('.tab').get(1).click();

            browser.waitForAngular();

            utils.common.takeScreenshot('user-profile', 'current-user-likes');
        });

        it('likes tab', async function() {
            let likesCount = await $$('div[infinite-scroll] > div').count();

            expect(likesCount).to.be.above(0);
        });

        it('likes tab - pagination', async function() {
            let startTotal = await $$('div[infinite-scroll] > div').count();

            let htmlChanges = await utils.common.outerHtmlChanges('div[infinite-scroll]');
            await browser.executeScript('window.scrollTo(0,document.body.scrollHeight)');
            await htmlChanges();

            let endTotal = await $$('div[infinite-scroll] > div').count();

            let hasMoreItems = startTotal < endTotal;

            expect(hasMoreItems).to.be.equal(true);
        });

        it('likes tab - filter projects', async function() {
            let allItems = await $('div[infinite-scroll]').getInnerHtml();

            await $$('div.filters > a').get(1).click();

            await browser.waitForAngular();

            let filteredItems = await $('div[infinite-scroll]').getInnerHtml();

            expect(allItems).to.be.not.equal(filteredItems);
        });

        it('likes tab - filter user stories', async function() {
            let allItems = await $('div[infinite-scroll]').getInnerHtml();

            await $$('div.filters > a').get(2).click();

            await browser.waitForAngular();

            let filteredItems = await $('div[infinite-scroll]').getInnerHtml();

            expect(allItems).to.be.not.equal(filteredItems);
        });

        it('likes tab - filter tasks', async function() {
            let allItems = await $('div[infinite-scroll]').getInnerHtml();

            await $$('div.filters > a').get(3).click();

            await browser.waitForAngular();

            let filteredItems = await $('div[infinite-scroll]').getInnerHtml();

            expect(allItems).to.be.not.equal(filteredItems);
        });

        it('likes tab - filter issues', async function() {
            let allItems = await $('div[infinite-scroll]').getInnerHtml();

            await $$('div.filters > a').get(4).click();

            await browser.waitForAngular();

            let filteredItems = await $('div[infinite-scroll]').getInnerHtml();

            expect(allItems).to.be.not.equal(filteredItems);
        });

        it('likes tab - filter by query', async function() {
            let allItems = await $$('div[infinite-scroll] > div').count();

            let htmlChanges = await utils.common.outerHtmlChanges('div[infinite-scroll]');
            $('div.searchbox > input').sendKeys('test');
            await htmlChanges();

            let filteredItems = await $$('div[infinite-scroll] > div').count();

            expect(allItems).to.be.not.equal(filteredItems);

            htmlChanges = await utils.common.outerHtmlChanges('div[infinite-scroll]');
            await utils.common.clear($('div.searchbox > input'));
            await htmlChanges();

            filteredItems = await $$('div[infinite-scroll] > div').count();

            expect(allItems).to.be.equal(filteredItems);
        });
    });

    describe('other user', function() {
        before(async function(){
            browser.get('http://localhost:9001/profile/user7');

            await utils.common.waitLoader();

            $$('.tab').get(2).click();

            browser.waitForAngular();

            utils.common.takeScreenshot('user-profile', 'other-user-likes');
        });

        it('likes tab', async function() {
            let likesCount = await $$('div[infinite-scroll] > div').count();

            expect(likesCount).to.be.above(0);
        });

        it('likes tab - pagination', async function() {
            let startTotal = await $$('div[infinite-scroll] > div').count();

            let htmlChanges = await utils.common.outerHtmlChanges('div[infinite-scroll]');
            await browser.executeScript('window.scrollTo(0,document.body.scrollHeight)');
            await htmlChanges();

            let endTotal = await $$('div[infinite-scroll] > div').count();

            let hasMoreItems = startTotal < endTotal;

            expect(hasMoreItems).to.be.equal(true);
        });

        it('likes tab - filter projects', async function() {
            let allItems = await $('div[infinite-scroll]').getInnerHtml();

            await $$('div.filters > a').get(1).click();

            await browser.waitForAngular();

            let filteredItems = await $('div[infinite-scroll]').getInnerHtml();

            expect(allItems).to.be.not.equal(filteredItems);
        });

        it('likes tab - filter user stories', async function() {
            let allItems = await $('div[infinite-scroll]').getInnerHtml();

            await $$('div.filters > a').get(2).click();

            await browser.waitForAngular();

            let filteredItems = await $('div[infinite-scroll]').getInnerHtml();

            expect(allItems).to.be.not.equal(filteredItems);
        });

        it('likes tab - filter tasks', async function() {
            let allItems = await $('div[infinite-scroll]').getInnerHtml();

            await $$('div.filters > a').get(3).click();

            await browser.waitForAngular();

            let filteredItems = await $('div[infinite-scroll]').getInnerHtml();

            expect(allItems).to.be.not.equal(filteredItems);
        });

        it('likes tab - filter issues', async function() {
            let allItems = await $('div[infinite-scroll]').getInnerHtml();

            await $$('div.filters > a').get(4).click();

            await browser.waitForAngular();

            let filteredItems = await $('div[infinite-scroll]').getInnerHtml();

            expect(allItems).to.be.not.equal(filteredItems);
        });

        it('likes tab - filter by query', async function() {
            let allItems = await $$('div[infinite-scroll] > div').count();

            let htmlChanges = await utils.common.outerHtmlChanges('div[infinite-scroll]');
            $('div.searchbox > input').sendKeys('test');
            await htmlChanges();

            let filteredItems = await $$('div[infinite-scroll] > div').count();

            expect(allItems).to.be.not.equal(filteredItems);

            htmlChanges = await utils.common.outerHtmlChanges('div[infinite-scroll]');
            await utils.common.clear($('div.searchbox > input'));
            await htmlChanges();

            filteredItems = await $$('div[infinite-scroll] > div').count();

            expect(allItems).to.be.equal(filteredItems);
        });

    });
});
