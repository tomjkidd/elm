(function (angular, Elm){
    angular.module('app')
        .directive('elmSimpleComponent', ElmSimpleComponent);

    ElmSimpleComponent.$inject = ['$q', '$timeout']
    function ElmSimpleComponent($q, $timeout) {
        return {
            restrict: 'A',
            scope: {
                initial: '='
            },
            controller: function ($scope, $element, $attrs, $transclude) {
                // Not needed for this directive...
            },
            link: function ($scope, element, attrs, controllers, transcludeFn) {

                // Elm.embed is used to attach to the DOM
                var app = Elm.embed(Elm.SimpleComponent, element[0], { toElm: '' });

                function handleFromElm (x) {

                    // Update the angular model, NOTE: The $timeout is needed!
                    $timeout(function () {
                        $scope.initial = x;
                    }, 0);

                    // Display what was received
                    console.log(x);
                };

                // fromElm.subscribe is used as a callback to handle messages coming from Elm
                var unsub = app.ports.fromElm.subscribe(handleFromElm);

                // Unsubscribe if the controller is destroyed.
                $scope.$on('$destroy', function() {
                    unsub();
                });

                // Send initial value to Elm
                $timeout(function () {
                    var init = $scope.initial == undefined ? '' : $scope.initial;
                    app.ports.toElm.send(init);
                }, 0)
            }
        }
    }

})(angular, Elm)
