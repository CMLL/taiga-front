class WatchButtonController
    @.$inject = [
        "$tgConfirm"
        "tgWatchButtonService"
    ]

    constructor: (@confirm, @watchButtonService)->
        @.showWatchOptions = false

    toggleWatcherOptions: ->
        @.showWatchOptions = not @.showWatchOptions

    watch: (notifyLevel) ->
        onSuccess = (project) =>
            @.project = project
            @.toggleWatcherOptions()
        onError = =>
            @.toggleWatcherOptions()
            @confirm.notify("error")

        @watchButtonService.watch(@.project, notifyLevel).then(onSuccess, onError)

    unwatch: ->
        onSuccess = (project) =>
            @.project = project
            @.toggleWatcherOptions()
        onError = =>
            @.toggleWatcherOptions()
            @confirm.notify("error")

        @watchButtonService.unwatch(@.project).then(onSuccess, onError)


angular.module("taigaComponents").controller("WatchButton", WatchButtonController)
