base = {
    scope: {},
    bindToController: {
        user: "="
        type: "@"
        q: "@"
        hasNoMorePages: "@"
        isLoading: "@"
        hasNoResults: "@"
    }
    controller: null, # Define in directives
    controllerAs: "vm",
    templateUrl: "profile/profile-favs/profile-favs.html",
}


####################################################
## Likes
####################################################

ProfileLikesDirective = () ->
    return _.extend({}, base, {
        controller: "ProfileLikes"
    })

angular.module("taigaProfile").directive("tgProfileLikes", ProfileLikesDirective)


####################################################
## Watched
####################################################

ProfileWatchedDirective = () ->
    return _.extend({}, base, {
        controller: "ProfileWatched"
    })

angular.module("taigaProfile").directive("tgProfileWatched", ProfileWatchedDirective)
