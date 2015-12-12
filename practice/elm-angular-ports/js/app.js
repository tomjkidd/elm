(function (angular, Elm){
    angular.module('app', [])
        .controller('UseElmController', UseElmController);

    UseElmController.$inject = ['$scope', '$q']
    function UseElmController($scope, $q) {
        $scope.first = 'The sky is blue'
        $scope.last = 'amanaplanacanalpanama'
    }
})(angular, Elm)
