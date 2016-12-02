(function () {
    'use strict';
    angular
    .module(global.config.APP_NAME)
    .service('GraphService', Service);

    Service.$inject = ['$q', '$uibModal' , '$http' ];

    function Service($q, $uibModal, $http) {
        var service = this;

        service.graphs = [];

        service.getGraphsList = function(graphId) {
            
            var deferred = $q.defer();

            $http.get("http://172.16.34.223:8085/rest/tssgraph/"+graphId)
                .success(function(result){
                    service.graphs = result.result;                    
                    deferred.resolve(result);
                })
                .error(function(error){
                    deferred.reject(error)
                });

            return deferred.promise;
        }

        service.addGraph = function(graph) {
            if( !graph || !graph.name || !graph.date )
                return null;

            var id = service.graph.length + 1;

            graph.id = id;

            graph.uDate = service.beautify(graph.date);

            service.graph.unshift(graph);
            return graph;
        }

        service.beautify = function(data) {
            var data = new Date(data);
            var dia = data.getDate();

            if (dia.toString().length == 1)
              dia = "0"+dia;

            var mes = data.getMonth()+1;
            if (mes.toString().length == 1)
              mes = "0"+mes;

            var ano = data.getFullYear();

            return dia+"/"+mes+"/"+ano;
        }

        service.completeGraph = function(graphIndex) {
            service.graphs.splice(graphIndex, 1);
        }

        service.getGraph = function(graphId) {
            for(var i = 0; i < service.graphs.length; i++ ) {
                if( service.graphs[i]._id == graphId ) {
                    return service.graphs[i];
                }
            }
            return null;
        }
    }

}());
