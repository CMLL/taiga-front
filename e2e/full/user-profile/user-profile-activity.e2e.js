var utils = require('../../utils');

var chai = require('chai');
var chaiAsPromised = require('chai-as-promised');

chai.use(chaiAsPromised);
var expect = chai.expect;

describe('user profile - activity', function() {
    describe('current user', function() {
        before(async function(){
            browser.get('http://localhost:9001/profile');

            await utils.common.waitLoader();

            utils.common.takeScreenshot('user-profile', 'current-user-activity');
        });

        it('activity tab - pagination', async function() {
            let startTotal = await $$('div[tg-user-timeline-item]').count();

            let htmlChanges = await utils.common.outerHtmlChanges('div[infinite-scroll]');
            await browser.executeScript('window.scrollTo(0,document.body.scrollHeight)');
            await htmlChanges();

            let endTotal = await $$('div[tg-user-timeline-item]').count();

            let hasMoreItems = startTotal < endTotal;

            expect(hasMoreItems).to.be.equal(true);
        });

        it('edit profile hover', async function() {
            let userImage = $('.profile-image-wrapper');

            await browser.actions().mouseMove(userImage).perform();

            let profileEdition = userImage.$('.profile-edition');

            await utils.common.waitTransitionTime(profileEdition);

            utils.common.takeScreenshot('user-profile', 'image-hover');

            expect(profileEdition.isDisplayed()).to.be.eventually.true;
        });
    });

    describe('other user', function() {
        before(async function(){
            browser.get('http://localhost:9001/profile/user7');

            await utils.common.waitLoader();

            utils.common.takeScreenshot('user-profile', 'other-user-activity');
        });

        it('activity tab pagination', async function() {
            let startTotal = await $$('div[tg-user-timeline-item]').count();

            let htmlChanges = await utils.common.outerHtmlChanges('div[infinite-scroll]');
            await browser.executeScript('window.scrollTo(0,document.body.scrollHeight)');
            await htmlChanges();

            let endTotal = await $$('div[tg-user-timeline-item]').count();

            let hasMoreItems = startTotal < endTotal;

            expect(hasMoreItems).to.be.equal(true);
        });
    });
});
