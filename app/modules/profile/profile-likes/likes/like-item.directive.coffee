LikeItemDirective = ->
    link = (scope, el, attrs, ctrl) ->
        scope.vm = {item: scope.item}

    templateUrl = (el, attrs) ->
        if attrs.itemType == "project"
            return "profile/profile-likes/likes/project.html"
        else # if attr.itemType in ["userstory", "task", "issue"]
            return "profile/profile-likes/likes/ticket.html"

    return {
        scope: {
            "item": "=tgLikeItem"
        }
        link: link
        templateUrl: templateUrl
    }


angular.module("taigaProfile").directive("tgLikeItem", LikeItemDirective)
