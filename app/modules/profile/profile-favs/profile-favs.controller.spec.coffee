describe "ProfileLikes", ->
    $controller = null
    provide = null
    $rootScope = null
    mocks = {}

    user = Immutable.fromJS({id: 2})

    _mockUserService = () ->
        mocks.userServices = {
            getLikes: sinon.stub()
        }

        provide.value "tgUserService", mocks.userServices

    _mocks = () ->
        module ($provide) ->
            provide = $provide
            _mockUserService()

            return null

    _inject = (callback) ->
        inject (_$controller_, _$rootScope_) ->
            $rootScope = _$rootScope_
            $controller = _$controller_

    beforeEach ->
        module "taigaProfile"
        _mocks()
        _inject()

    it "load paginated items", (done) ->
        $scope = $rootScope.$new()
        ctrl = $controller("ProfileLikes", $scope, {user: user})
        ctrl._enableLoadingSpinner = sinon.stub()
        ctrl._disableLoadingSpinner = sinon.stub()

        items1 = Immutable.fromJS({
            data: [
                {id: 1},
                {id: 2},
                {id: 3}
            ],
            next: true
        })
        items2 = Immutable.fromJS({
            data: [
                {id: 4},
                {id: 5},
            ],
            next: false
        })

        mocks.userServices.getLikes.withArgs(user.get("id"), 1, null, null).promise().resolve(items1)
        mocks.userServices.getLikes.withArgs(user.get("id"), 2, null, null).promise().resolve(items2)

        expect(ctrl.items.size).to.be.equal(0)
        expect(ctrl.hasNoMorePages).to.be.false
        expect(ctrl._page).to.be.equal(1)
        expect(ctrl.type).to.be.null
        expect(ctrl.q).to.be.null
        expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(0)
        expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(0)

        ctrl.loadItems().then () =>
            expectItems = items1.get("data")

            expect(ctrl.items.size).to.be.equal(3)
            expect(ctrl.items.equals(expectItems)).to.be.true
            expect(ctrl.hasNoMorePages).to.be.true
            expect(ctrl._page).to.be.equal(2)
            expect(ctrl.type).to.be.null
            expect(ctrl.q).to.be.null
            expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(1)
            expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(1)

            ctrl.loadItems().then () =>
                expectItems = expectItems.concat(items2.get("data"))

                expect(ctrl.items.size).to.be.equal(5)
                expect(ctrl.items.equals(expectItems)).to.be.true
                expect(ctrl.hasNoMorePages).to.be.false
                expect(ctrl._page).to.be.equal(2)
                expect(ctrl.type).to.be.null
                expect(ctrl.q).to.be.null
                expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(2)
                expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(2)
                done()

    it "filter items by text query", (done) ->
        $scope = $rootScope.$new()
        ctrl = $controller("ProfileLikes", $scope, {user: user})
        ctrl._enableLoadingSpinner = sinon.stub()
        ctrl._disableLoadingSpinner = sinon.stub()

        textQuery = "_test_"

        items = Immutable.fromJS({
            data: [
                {id: 1},
                {id: 2},
                {id: 3}
            ],
            next: true
        })

        mocks.userServices.getLikes.withArgs(user.get("id"), 1, null, textQuery).promise().resolve(items)

        expect(ctrl.items.size).to.be.equal(0)
        expect(ctrl.hasNoMorePages).to.be.false
        expect(ctrl._page).to.be.equal(1)
        expect(ctrl.type).to.be.null
        expect(ctrl.q).to.be.null
        expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(0)
        expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(0)

        ctrl.q = textQuery

        ctrl.loadItems().then () =>
            expectItems = items.get("data")

            expect(ctrl.items.size).to.be.equal(3)
            expect(ctrl.items.equals(expectItems)).to.be.true
            expect(ctrl.hasNoMorePages).to.be.true
            expect(ctrl._page).to.be.equal(2)
            expect(ctrl.type).to.be.null
            expect(ctrl.q).to.be.equal(textQuery)
            expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(1)
            expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(1)
            done()

    it "show only items of projects", (done) ->
        $scope = $rootScope.$new()
        ctrl = $controller("ProfileLikes", $scope, {user: user})
        ctrl._enableLoadingSpinner = sinon.stub()
        ctrl._disableLoadingSpinner = sinon.stub()
        ctrl._resetList = sinon.stub()

        type = "project"

        items = Immutable.fromJS({
            data: [
                {id: 1},
                {id: 2},
                {id: 3}
            ],
            next: true
        })

        mocks.userServices.getLikes.withArgs(user.get("id"), 1, type, null).promise().resolve(items)

        expect(ctrl.items.size).to.be.equal(0)
        expect(ctrl.hasNoMorePages).to.be.false
        expect(ctrl._page).to.be.equal(1)
        expect(ctrl.type).to.be.null
        expect(ctrl.q).to.be.null
        expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(0)
        expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(0)
        expect(ctrl._resetList.callCount).to.be.equal(0)

        ctrl.showProjectsOnly().then () =>
            expectItems = items.get("data")

            expect(ctrl.items.size).to.be.equal(3)
            expect(ctrl.items.equals(expectItems)).to.be.true
            expect(ctrl.hasNoMorePages).to.be.true
            expect(ctrl._page).to.be.equal(2)
            expect(ctrl.type).to.be.type
            expect(ctrl.q).to.be.null
            expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(1)
            expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(1)
            expect(ctrl._resetList.callCount).to.be.equal(1)
            done()

    it "show only items of user stories", (done) ->
        $scope = $rootScope.$new()
        ctrl = $controller("ProfileLikes", $scope, {user: user})
        ctrl._enableLoadingSpinner = sinon.stub()
        ctrl._disableLoadingSpinner = sinon.stub()
        ctrl._resetList = sinon.stub()

        type = "userstory"

        items = Immutable.fromJS({
            data: [
                {id: 1},
                {id: 2},
                {id: 3}
            ],
            next: true
        })

        mocks.userServices.getLikes.withArgs(user.get("id"), 1, type, null).promise().resolve(items)

        expect(ctrl.items.size).to.be.equal(0)
        expect(ctrl.hasNoMorePages).to.be.false
        expect(ctrl._page).to.be.equal(1)
        expect(ctrl.type).to.be.null
        expect(ctrl.q).to.be.null
        expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(0)
        expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(0)
        expect(ctrl._resetList.callCount).to.be.equal(0)

        ctrl.showUserStoriesOnly().then () =>
            expectItems = items.get("data")

            expect(ctrl.items.size).to.be.equal(3)
            expect(ctrl.items.equals(expectItems)).to.be.true
            expect(ctrl.hasNoMorePages).to.be.true
            expect(ctrl._page).to.be.equal(2)
            expect(ctrl.type).to.be.type
            expect(ctrl.q).to.be.null
            expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(1)
            expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(1)
            expect(ctrl._resetList.callCount).to.be.equal(1)
            done()

    it "show only items of tasks", (done) ->
        $scope = $rootScope.$new()
        ctrl = $controller("ProfileLikes", $scope, {user: user})
        ctrl._enableLoadingSpinner = sinon.stub()
        ctrl._disableLoadingSpinner = sinon.stub()
        ctrl._resetList = sinon.stub()

        type = "task"

        items = Immutable.fromJS({
            data: [
                {id: 1},
                {id: 2},
                {id: 3}
            ],
            next: true
        })

        mocks.userServices.getLikes.withArgs(user.get("id"), 1, type, null).promise().resolve(items)

        expect(ctrl.items.size).to.be.equal(0)
        expect(ctrl.hasNoMorePages).to.be.false
        expect(ctrl._page).to.be.equal(1)
        expect(ctrl.type).to.be.null
        expect(ctrl.q).to.be.null
        expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(0)
        expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(0)
        expect(ctrl._resetList.callCount).to.be.equal(0)

        ctrl.showTasksOnly().then () =>
            expectItems = items.get("data")

            expect(ctrl.items.size).to.be.equal(3)
            expect(ctrl.items.equals(expectItems)).to.be.true
            expect(ctrl.hasNoMorePages).to.be.true
            expect(ctrl._page).to.be.equal(2)
            expect(ctrl.type).to.be.type
            expect(ctrl.q).to.be.null
            expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(1)
            expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(1)
            expect(ctrl._resetList.callCount).to.be.equal(1)
            done()

    it "show only items of issues", (done) ->
        $scope = $rootScope.$new()
        ctrl = $controller("ProfileLikes", $scope, {user: user})
        ctrl._enableLoadingSpinner = sinon.stub()
        ctrl._disableLoadingSpinner = sinon.stub()
        ctrl._resetList = sinon.stub()

        type = "issue"

        items = Immutable.fromJS({
            data: [
                {id: 1},
                {id: 2},
                {id: 3}
            ],
            next: true
        })

        mocks.userServices.getLikes.withArgs(user.get("id"), 1, type, null).promise().resolve(items)

        expect(ctrl.items.size).to.be.equal(0)
        expect(ctrl.hasNoMorePages).to.be.false
        expect(ctrl._page).to.be.equal(1)
        expect(ctrl.type).to.be.null
        expect(ctrl.q).to.be.null
        expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(0)
        expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(0)
        expect(ctrl._resetList.callCount).to.be.equal(0)

        ctrl.showIssuesOnly().then () =>
            expectItems = items.get("data")

            expect(ctrl.items.size).to.be.equal(3)
            expect(ctrl.items.equals(expectItems)).to.be.true
            expect(ctrl.hasNoMorePages).to.be.true
            expect(ctrl._page).to.be.equal(2)
            expect(ctrl.type).to.be.type
            expect(ctrl.q).to.be.null
            expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(1)
            expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(1)
            expect(ctrl._resetList.callCount).to.be.equal(1)
            done()


describe "ProfileWatched", ->
    $controller = null
    provide = null
    $rootScope = null
    mocks = {}

    user = Immutable.fromJS({id: 2})

    _mockUserService = () ->
        mocks.userServices = {
            getWatched: sinon.stub()
        }

        provide.value "tgUserService", mocks.userServices

    _mocks = () ->
        module ($provide) ->
            provide = $provide
            _mockUserService()

            return null

    _inject = (callback) ->
        inject (_$controller_, _$rootScope_) ->
            $rootScope = _$rootScope_
            $controller = _$controller_

    beforeEach ->
        module "taigaProfile"
        _mocks()
        _inject()

    it "load paginated items", (done) ->
        $scope = $rootScope.$new()
        ctrl = $controller("ProfileWatched", $scope, {user: user})
        ctrl._enableLoadingSpinner = sinon.stub()
        ctrl._disableLoadingSpinner = sinon.stub()

        items1 = Immutable.fromJS({
            data: [
                {id: 1},
                {id: 2},
                {id: 3}
            ],
            next: true
        })
        items2 = Immutable.fromJS({
            data: [
                {id: 4},
                {id: 5},
            ],
            next: false
        })

        mocks.userServices.getWatched.withArgs(user.get("id"), 1, null, null).promise().resolve(items1)
        mocks.userServices.getWatched.withArgs(user.get("id"), 2, null, null).promise().resolve(items2)

        expect(ctrl.items.size).to.be.equal(0)
        expect(ctrl.hasNoMorePages).to.be.false
        expect(ctrl._page).to.be.equal(1)
        expect(ctrl.type).to.be.null
        expect(ctrl.q).to.be.null
        expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(0)
        expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(0)

        ctrl.loadItems().then () =>
            expectItems = items1.get("data")

            expect(ctrl.items.size).to.be.equal(3)
            expect(ctrl.items.equals(expectItems)).to.be.true
            expect(ctrl.hasNoMorePages).to.be.true
            expect(ctrl._page).to.be.equal(2)
            expect(ctrl.type).to.be.null
            expect(ctrl.q).to.be.null
            expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(1)
            expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(1)

            ctrl.loadItems().then () =>
                expectItems = expectItems.concat(items2.get("data"))

                expect(ctrl.items.size).to.be.equal(5)
                expect(ctrl.items.equals(expectItems)).to.be.true
                expect(ctrl.hasNoMorePages).to.be.false
                expect(ctrl._page).to.be.equal(2)
                expect(ctrl.type).to.be.null
                expect(ctrl.q).to.be.null
                expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(2)
                expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(2)
                done()

    it "filter items by text query", (done) ->
        $scope = $rootScope.$new()
        ctrl = $controller("ProfileWatched", $scope, {user: user})
        ctrl._enableLoadingSpinner = sinon.stub()
        ctrl._disableLoadingSpinner = sinon.stub()

        textQuery = "_test_"

        items = Immutable.fromJS({
            data: [
                {id: 1},
                {id: 2},
                {id: 3}
            ],
            next: true
        })

        mocks.userServices.getWatched.withArgs(user.get("id"), 1, null, textQuery).promise().resolve(items)

        expect(ctrl.items.size).to.be.equal(0)
        expect(ctrl.hasNoMorePages).to.be.false
        expect(ctrl._page).to.be.equal(1)
        expect(ctrl.type).to.be.null
        expect(ctrl.q).to.be.null
        expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(0)
        expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(0)

        ctrl.q = textQuery

        ctrl.loadItems().then () =>
            expectItems = items.get("data")

            expect(ctrl.items.size).to.be.equal(3)
            expect(ctrl.items.equals(expectItems)).to.be.true
            expect(ctrl.hasNoMorePages).to.be.true
            expect(ctrl._page).to.be.equal(2)
            expect(ctrl.type).to.be.null
            expect(ctrl.q).to.be.equal(textQuery)
            expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(1)
            expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(1)
            done()

    it "show only items of projects", (done) ->
        $scope = $rootScope.$new()
        ctrl = $controller("ProfileWatched", $scope, {user: user})
        ctrl._enableLoadingSpinner = sinon.stub()
        ctrl._disableLoadingSpinner = sinon.stub()
        ctrl._resetList = sinon.stub()

        type = "project"

        items = Immutable.fromJS({
            data: [
                {id: 1},
                {id: 2},
                {id: 3}
            ],
            next: true
        })

        mocks.userServices.getWatched.withArgs(user.get("id"), 1, type, null).promise().resolve(items)

        expect(ctrl.items.size).to.be.equal(0)
        expect(ctrl.hasNoMorePages).to.be.false
        expect(ctrl._page).to.be.equal(1)
        expect(ctrl.type).to.be.null
        expect(ctrl.q).to.be.null
        expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(0)
        expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(0)
        expect(ctrl._resetList.callCount).to.be.equal(0)

        ctrl.showProjectsOnly().then () =>
            expectItems = items.get("data")

            expect(ctrl.items.size).to.be.equal(3)
            expect(ctrl.items.equals(expectItems)).to.be.true
            expect(ctrl.hasNoMorePages).to.be.true
            expect(ctrl._page).to.be.equal(2)
            expect(ctrl.type).to.be.type
            expect(ctrl.q).to.be.null
            expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(1)
            expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(1)
            expect(ctrl._resetList.callCount).to.be.equal(1)
            done()

    it "show only items of user stories", (done) ->
        $scope = $rootScope.$new()
        ctrl = $controller("ProfileWatched", $scope, {user: user})
        ctrl._enableLoadingSpinner = sinon.stub()
        ctrl._disableLoadingSpinner = sinon.stub()
        ctrl._resetList = sinon.stub()

        type = "userstory"

        items = Immutable.fromJS({
            data: [
                {id: 1},
                {id: 2},
                {id: 3}
            ],
            next: true
        })

        mocks.userServices.getWatched.withArgs(user.get("id"), 1, type, null).promise().resolve(items)

        expect(ctrl.items.size).to.be.equal(0)
        expect(ctrl.hasNoMorePages).to.be.false
        expect(ctrl._page).to.be.equal(1)
        expect(ctrl.type).to.be.null
        expect(ctrl.q).to.be.null
        expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(0)
        expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(0)
        expect(ctrl._resetList.callCount).to.be.equal(0)

        ctrl.showUserStoriesOnly().then () =>
            expectItems = items.get("data")

            expect(ctrl.items.size).to.be.equal(3)
            expect(ctrl.items.equals(expectItems)).to.be.true
            expect(ctrl.hasNoMorePages).to.be.true
            expect(ctrl._page).to.be.equal(2)
            expect(ctrl.type).to.be.type
            expect(ctrl.q).to.be.null
            expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(1)
            expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(1)
            expect(ctrl._resetList.callCount).to.be.equal(1)
            done()

    it "show only items of tasks", (done) ->
        $scope = $rootScope.$new()
        ctrl = $controller("ProfileWatched", $scope, {user: user})
        ctrl._enableLoadingSpinner = sinon.stub()
        ctrl._disableLoadingSpinner = sinon.stub()
        ctrl._resetList = sinon.stub()

        type = "task"

        items = Immutable.fromJS({
            data: [
                {id: 1},
                {id: 2},
                {id: 3}
            ],
            next: true
        })

        mocks.userServices.getWatched.withArgs(user.get("id"), 1, type, null).promise().resolve(items)

        expect(ctrl.items.size).to.be.equal(0)
        expect(ctrl.hasNoMorePages).to.be.false
        expect(ctrl._page).to.be.equal(1)
        expect(ctrl.type).to.be.null
        expect(ctrl.q).to.be.null
        expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(0)
        expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(0)
        expect(ctrl._resetList.callCount).to.be.equal(0)

        ctrl.showTasksOnly().then () =>
            expectItems = items.get("data")

            expect(ctrl.items.size).to.be.equal(3)
            expect(ctrl.items.equals(expectItems)).to.be.true
            expect(ctrl.hasNoMorePages).to.be.true
            expect(ctrl._page).to.be.equal(2)
            expect(ctrl.type).to.be.type
            expect(ctrl.q).to.be.null
            expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(1)
            expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(1)
            expect(ctrl._resetList.callCount).to.be.equal(1)
            done()

    it "show only items of issues", (done) ->
        $scope = $rootScope.$new()
        ctrl = $controller("ProfileWatched", $scope, {user: user})
        ctrl._enableLoadingSpinner = sinon.stub()
        ctrl._disableLoadingSpinner = sinon.stub()
        ctrl._resetList = sinon.stub()

        type = "issue"

        items = Immutable.fromJS({
            data: [
                {id: 1},
                {id: 2},
                {id: 3}
            ],
            next: true
        })

        mocks.userServices.getWatched.withArgs(user.get("id"), 1, type, null).promise().resolve(items)

        expect(ctrl.items.size).to.be.equal(0)
        expect(ctrl.hasNoMorePages).to.be.false
        expect(ctrl._page).to.be.equal(1)
        expect(ctrl.type).to.be.null
        expect(ctrl.q).to.be.null
        expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(0)
        expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(0)
        expect(ctrl._resetList.callCount).to.be.equal(0)

        ctrl.showIssuesOnly().then () =>
            expectItems = items.get("data")

            expect(ctrl.items.size).to.be.equal(3)
            expect(ctrl.items.equals(expectItems)).to.be.true
            expect(ctrl.hasNoMorePages).to.be.true
            expect(ctrl._page).to.be.equal(2)
            expect(ctrl.type).to.be.type
            expect(ctrl.q).to.be.null
            expect(ctrl._enableLoadingSpinner.callCount).to.be.equal(1)
            expect(ctrl._disableLoadingSpinner.callCount).to.be.equal(1)
            expect(ctrl._resetList.callCount).to.be.equal(1)
            done()
