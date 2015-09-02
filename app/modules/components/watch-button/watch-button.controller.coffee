class WatchButtonController
    @.$inject = [
        "$tgConfirm"
        "tgWatchButtonService"
    ]

    constructor: (@confirm, @watchButtonService)->
        @.showWatchOptions = false

    toggleWatcherOptions: ->
        @.showWatchOptions = not @.showWatchOptions

    # NOTIFICATIONS CHOICES:
    #   1 - Only involved
    #   2 - Receive all
    #   3 - No notifications

    watchAndNotifyAll: () -> @._watch(2)

    watchAndNotifyInvolved: () -> @._watch(1)

    watchAndNotifyNone: () -> @._watch(3)

    _watch: (notifyPolicy) ->
        onSuccess = (project) =>
            @.project = project
            @.toggleWatcherOptions()
        onError = =>
            @.toggleWatcherOptions()
            @confirm.notify("error")

        @watchButtonService.watch(@.project, notifyPolicy).then(onSuccess, onError)

angular.module("taigaComponents").controller("WatchButton", WatchButtonController)
