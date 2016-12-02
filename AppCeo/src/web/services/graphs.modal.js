(function () {
    'use strict';
    angular
        .module(global.config.APP_NAME)
        .service('GraphModal', Service);

    Service.$inject = ['$q', '$uibModal'];

    function Service($q, $uibModal) {
        var service = this;

        service.show = function(pMsg, pType) {
            var controller = ['$scope', '$uibModalInstance', '$timeout', 'options', function($scope, $uibModalInstance, $timeout, options){

                $scope.newGraph = null;

                $scope.select = function(){
                    if( !$scope.newGrap )
                        return;

                    if( !$scope.newGrap.name )
                        return;

                    if( !$scope.newGraph.date )
                        $scope.newGraph.date = new Date();

                    $uibModalInstance.close($scope.newGraph);
                }

                $scope.cancel = function(){
                    $uibModalInstance.close();
                }

                $scope.nameKeyPress = function(keyEvent) {
                    if (keyEvent.which === 13) {
                        $scope.select();
                    }
                };
                $timeout(function(){angular.element('#name').focus();},0);
            }];

            var modalInstance = $uibModal.open({
                animation: true,
                templateUrl: './templates/graph-modal-template.html',
                controller: controller,
                size: 'lg',
                backdrop: true,
                //windowClass: 'totvs-notification-modal',
                resolve: {
                    options : function() {
                        return {
                            msg : pMsg,
                            type : pType
                        }
                    }
                }
            });

            return modalInstance.result;
        }
        return service;
    }
}());
