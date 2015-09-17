class VoteButtonController
    constructor: ->

    toggleVote: ->
        if not @.item.is_voted
            @._upvote()
        else
            @._downvote()

    _upvote: ->
        @.onUpvote()

    _downvote: ->
        @.onDownvote()

angular.module("taigaComponents").controller("VoteButton", VoteButtonController)
