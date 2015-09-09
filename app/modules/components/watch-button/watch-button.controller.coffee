class WatchButtonController
    @.$inject = [
        "$tgConfirm"
        "tgWatchButtonService"
    ]

    constructor: (@confirm, @watchButtonService)->
        @.showWatchOptions = false

    toggleWatcherOptions: () ->
        @.showWatchOptions = !@.showWatchOptions

    watch: (notifyLevel) ->
        return @watchButtonService.watch(@.project.get('id'), notifyLevel)
            .catch () => @confirm.notify("error")
            .finally () => @.showWatchOptions = false

    unwatch: ->
        return @watchButtonService.unwatch(@.project.get('id'))
            .catch () => @confirm.notify("error")
            .finally () => @.showWatchOptions = false

angular.module("taigaComponents").controller("WatchButton", WatchButtonController)
