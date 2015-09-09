describe "LikeButton", ->
    $provide = null
    $controller = null
    mocks = {}

    _mockTgConfirm = ->
        mocks.tgConfirm = {
            notify: sinon.stub()
        }

        $provide.value("$tgConfirm", mocks.tgConfirm)

    _mockTgLikeButton = ->
        mocks.tgLikeButton = {
            like: sinon.stub(),
            unlike: sinon.stub()
        }

        $provide.value("tgLikeButtonService", mocks.tgLikeButton)

    _mocks = ->
        module (_$provide_) ->
            $provide = _$provide_

            _mockTgConfirm()
            _mockTgLikeButton()

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

    it "toggleLike false -> true", () ->
        project = Immutable.fromJS({
            id: 3,
            is_liked: false
        })

        ctrl = $controller("LikeButton")
        ctrl.project = project

        mocks.tgLikeButton.like.withArgs(project.get('id')).promise().resolve()

        ctrl.toggleLike()

        expect(mocks.tgLikeButton.like).to.be.calledOnce

    it "toggleLike false -> true, notify error", (done) ->
        project = Immutable.fromJS({
            id: 3,
            is_liked: false
        })

        ctrl = $controller("LikeButton")
        ctrl.project = project

        mocks.tgLikeButton.like.withArgs(project.get('id')).promise().reject()

        ctrl.toggleLike().finally () ->
            expect(mocks.tgConfirm.notify.withArgs("error")).to.be.calledOnce
            done()

    it "toggleLike true -> false", () ->
        project = Immutable.fromJS({
            is_liked: true
        })

        ctrl = $controller("LikeButton")
        ctrl.project = project

        mocks.tgLikeButton.unlike.withArgs(project.get('id')).promise().resolve()

        ctrl.toggleLike()

        expect(mocks.tgLikeButton.unlike).to.be.calledOnce

    it "toggleLike true -> false, notify error", (done) ->
        project = Immutable.fromJS({
            is_liked: true
        })

        ctrl = $controller("LikeButton")
        ctrl.project = project

        mocks.tgLikeButton.unlike.withArgs(project.get('id')).promise().reject()

        ctrl.toggleLike().finally () ->
            expect(mocks.tgConfirm.notify.withArgs("error")).to.be.calledOnce
            done()
