(function () {
    'use strict';
    angular
        .module(global.config.APP_NAME)
        .controller('GraphDetailController', Controller);

    Controller.$inject = [
        '$scope',
        '$stateParams',
        '$filter',
        'GraphService',
        '$http',
        '$state'
    ];

    function Controller($scope, $stateParams, $filter, GraphService ) {
        var controller = this;
        var produto = [];       
       
        GraphService.getGraphsList($stateParams.graphs)
        .then(function(result){   
            var total =  [];    
            var i = 0;
            var len = result.result.length;          

            total.push(result.result[0][2]);
            produto.push(result.result[0][1]);
               

            for (i = 0; i < len; i++) { 
                total.push(result.result[i][2]);
                produto.push(result.result[i][1]);
            }

            controller.chart.series = [
                {color: '#1E90FF', data: total}
            ];
                    
        },
            function(error){
                console.log(error);                  
        });
     
        controller.graphs = [];
        controller.haveMore = false;
        controller.chart = {};

        controller.chart.title = {
            position: "top",
            text: "Mais Vendas",
            font: '18px Arial,Helvetica,sans-serif'
        };

        controller.chart.categories = {
            labels: {
                rotation: 'auto'
            },            
            categories: produto,
            majorGridLines: {
                visible: true
            }
        };           

        controller.chart.type = { type: 'area' };
     
        // Controle de animação pois esta tela é de detalhes, e deve deslizar do lado, e não fazer o fade padrão.
        controller.anim = 'anim-slide-left';
        $scope.$on('animEnd', function($event, element, speed) {
            controller.anim = 'anim-slide-right';
        });
           
    }
}());
