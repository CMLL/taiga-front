describe "WatchButton", ->
    $provide = null
    $controller = null
    mocks = {}

    _mockTgConfirm = ->
        mocks.tgConfirm = {
            notify: sinon.stub()
        }

        $provide.value("$tgConfirm", mocks.tgConfirm)

    _mockTgWatchButton = ->
        mocks.tgWatchButton = {
            watch: sinon.stub(),
            unwatch: sinon.stub()
        }

        $provide.value("tgWatchButtonService", mocks.tgWatchButton)

    _mocks = ->
        module (_$provide_) ->
            $provide = _$provide_

            _mockTgConfirm()
            _mockTgWatchButton()

            return null

    _inject = ->
        inject (_$controller_) ->
            $controller = _$controller_

    _setup = ->
        _mocks()
        _inject()

    beforeEach ->
        module "taigaComponents"

        _setup()

    it "toggleWatcherOption", () ->
        ctrl = $controller("WatchButton")

        ctrl.toggleWatcherOptions()

        expect(ctrl.showWatchOptions).to.be.true

        ctrl.toggleWatcherOptions()

        expect(ctrl.showWatchOptions).to.be.false

    it "watch", (done) ->
        notifyLevel = 5
        project = Immutable.fromJS({
            id: 3
        })

        ctrl = $controller("WatchButton")
        ctrl.project = project
        ctrl.showWatchOptions = true

        mocks.tgWatchButton.watch.withArgs(project.get('id'), notifyLevel).promise().resolve()

        ctrl.watch(notifyLevel).finally () ->
            expect(mocks.tgWatchButton.watch).to.be.calledOnce
            expect(ctrl.showWatchOptions).to.be.false

            done()

    it "watch, notify error", (done) ->
        notifyLevel = 5
        project = Immutable.fromJS({
            id: 3
        })

        ctrl = $controller("WatchButton")
        ctrl.project = project
        ctrl.showWatchOptions = true

        mocks.tgWatchButton.watch.withArgs(project.get('id'), notifyLevel).promise().reject()

        ctrl.watch(notifyLevel).finally () ->
            expect(mocks.tgConfirm.notify.withArgs("error")).to.be.calledOnce
            expect(ctrl.showWatchOptions).to.be.false

            done()

    it "unwatch", (done) ->
        project = Immutable.fromJS({
            id: 3
        })

        ctrl = $controller("WatchButton")
        ctrl.project = project
        ctrl.showWatchOptions = true

        mocks.tgWatchButton.unwatch.withArgs(project.get('id')).promise().resolve()

        ctrl.unwatch().finally () ->
            expect(mocks.tgWatchButton.unwatch).to.be.calledOnce
            expect(ctrl.showWatchOptions).to.be.false

            done()

    it "unwatch, notify error", (done) ->
        project = Immutable.fromJS({
            id: 3
        })

        ctrl = $controller("WatchButton")
        ctrl.project = project
        ctrl.showWatchOptions = true

        mocks.tgWatchButton.unwatch.withArgs(project.get('id')).promise().reject()

        ctrl.unwatch().finally () ->
            expect(mocks.tgConfirm.notify.withArgs("error")).to.be.calledOnce
            expect(ctrl.showWatchOptions).to.be.false

            done()
