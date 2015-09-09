describe "tgLikeButtonService", ->
    likeButtonService = null
    provide = null
    mocks = {}

    _mockTgResources = () ->
        mocks.tgResources = {
            projects: {
                likeProject: sinon.stub(),
                unlikeProject: sinon.stub()
            }
        }

        provide.value "tgResources", mocks.tgResources

    _mockTgCurrentUserService = () ->
        mocks.tgCurrentUserService = {
            setProjects: sinon.stub(),
            projects: Immutable.fromJS({
                all: [
                    {
                        id: 4,
                        likes: 2,
                        is_liked: false
                    },
                    {
                        id: 5,
                        likes: 7,
                        is_liked: true
                    },
                    {
                        id: 6,
                        likes: 4,
                        is_liked: true
                    }
                ]
            })
        }

        provide.value "tgCurrentUserService", mocks.tgCurrentUserService

    _mockTgProjectService = () ->
        mocks.tgProjectService = {
            setProject: sinon.stub()
        }

        provide.value "tgProjectService", mocks.tgProjectService

    _inject = (callback) ->
        inject (_tgLikeButtonService_) ->
            likeButtonService = _tgLikeButtonService_
            callback() if callback

    _mocks = () ->
        module ($provide) ->
            provide = $provide
            _mockTgResources()
            _mockTgCurrentUserService()
            _mockTgProjectService()
            return null

    _setup = ->
        _mocks()

    beforeEach ->
        module "taigaComponents"
        _setup()
        _inject()

    it "like", (done) ->
        projectId = 4

        mocks.tgResources.projects.likeProject.withArgs(projectId).promise().resolve()

        newProject = {
            id: 4,
            likes: 3,
            is_liked: true
        }

        mocks.tgProjectService.project =  mocks.tgCurrentUserService.projects.getIn(['all', 0])

        userServiceCheckImmutable = sinon.match ((immutable) ->
            immutable = immutable.toJS()

            return _.isEqual(immutable[0], newProject)
        ), 'userServiceCheckImmutable'

        projectServiceCheckImmutable = sinon.match ((immutable) ->
            immutable = immutable.toJS()

            return _.isEqual(immutable, newProject)
        ), 'projectServiceCheckImmutable'


        likeButtonService.like(projectId).finally () ->
            expect(mocks.tgCurrentUserService.setProjects).to.have.been.calledWith(userServiceCheckImmutable)
            expect(mocks.tgProjectService.setProject).to.have.been.calledWith(projectServiceCheckImmutable)

            done()

    it "unlike", (done) ->
        projectId = 5

        mocks.tgResources.projects.unlikeProject.withArgs(projectId).promise().resolve()

        newProject =  {
            id: 5,
            likes: 6,
            is_liked: false
        }

        mocks.tgProjectService.project =  mocks.tgCurrentUserService.projects.getIn(['all', 1])

        userServiceCheckImmutable = sinon.match ((immutable) ->
            immutable = immutable.toJS()

            return _.isEqual(immutable[1], newProject)
        ), 'userServiceCheckImmutable'

        projectServiceCheckImmutable = sinon.match ((immutable) ->
            immutable = immutable.toJS()

            return _.isEqual(immutable, newProject)
        ), 'projectServiceCheckImmutable'


        likeButtonService.unlike(projectId).finally () ->
            expect(mocks.tgCurrentUserService.setProjects).to.have.been.calledWith(userServiceCheckImmutable)
            expect(mocks.tgProjectService.setProject).to.have.been.calledWith(projectServiceCheckImmutable)

            done()
