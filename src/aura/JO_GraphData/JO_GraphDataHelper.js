({  
    loadBarChart : function(component, event, helper){
        debugger;
        var action = component.get("c.getBarChartData");        
        var param = component.get('v.jobOwnerIds');        
        action.setStorable();
        action.setParams({ 
            jobOwnerIds : param, 
            userConfigRec : component.get('v.dashboardRec')
        });
        action.setCallback(this , function(a) {
            if (a.getState() === "SUCCESS") {
                var menu = a.getReturnValue();
            }                        
            var val = JSON.stringify(menu); 
           
            var count = 0;
            var user_data = [];
            //var drill_down_data = [];
            jQuery.each(JSON.parse(val), function( index, value ) {
                var user = {};
                user.name = value.drill.Name;
                user.y = parseInt(value.drill.count);
                user.drilldown = value.drill.Name;
                user_data.push(user); 
                count += parseInt(value.drill.count);
            });    
            component.set('v.count',count);
            Highcharts.chart('containerBar',{
              chart: {
                  type: 'column',
                  height: 230,
                  /*events: {
                      drilldown:  function (evn) {
                          alert('!!!'+evn);                                 
                      }                            
                  }*/                        
                },
                title: {
                    text: '',                        
                },
                exporting: { enabled: true },
                subtitle: {
                    text: ''
                },
                xAxis: {
                    type: 'category',
                    title: {
                        text: ''
                    }
                },
                yAxis: {
                    gridLineWidth: 0,
                    title: {
                        text: ''
                    },
                    labels: {
                        enabled: false
                    }
                },
                legend: {
                    enabled: false
                },
                plotOptions: {
                    series: {
                        borderWidth: 0,
                        dataLabels: {
                            enabled: true
                        },
                        cursor:'pointer',
                        point:
                        {
                          events:
                          {
                            click: function()
                            { 
                              console.log(this.name);
                              var status = this.name;                  
                              var chartEvent = $A.get("e.c:JO_PassSelectedStatus");
                              chartEvent.setParams({
                                SelectedStatus: status,
                              });
                              chartEvent.fire();                       
                            }
                          }
                        }                        
                    }
                },                    
                credits:{
                    enabled:false
                },
                series: [{
                    name: 'Total',
                    colorByPoint: true,
                    data: user_data
                }],
            });
            helper.hideWaiting(component, event, helper);
        });
        $A.enqueueAction(action);        
    },
    loadPieChart : function(component, event, helper) {
        var action = component.get("c.getPieChartData");
        var param = component.get('v.jobOwnerIds');
        action.setStorable();
        action.setParams({
          jobOwnerIds : param,
          userConfigRec : component.get('v.dashboardRec')
        });
        action.setCallback(this , function(a)
         {
             var state = a.getState();
             if (state === "SUCCESS") {
                 var menu = a.getReturnValue();                          
             }
             var pieArr= [];   
             jQuery.each(menu, function( index, value ) {
                 var ser=[value.name,value.data];
                 pieArr.push(ser);

             }); 
              Highcharts.chart('containerPie', {
                  chart: {
                    type: 'pie',
  		              height: 200,                              
                  },                          
                  title: {
                      text: '',                              
                  },
                  plotOptions: {
                      pie: {
                          allowPointSelect: true,
                          dataLabels: {                                      
                              format: '<b>{point.name}:</b>({point.percentage:.1f}%)',
                              /*style: {
                                  color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                              }*/
                          },
                          showInLegend: false,
                      },
                      series:
                      {
                          cursor:'pointer',
                          point:
                          {
                            events:
                            {
                                click: function()
                                { 
                                  console.log(this.name);                                             
                                  var status = this.name;                             
                                  var chartEvent = $A.get("e.c:JO_PassSelectedStatus");
                                  chartEvent.setParams({
                                    SelectedStatus: status,
                                  });
                                  chartEvent.fire();
                                }
                            }
                          }
                      }
                  },
                  credits:
                  {
                      enabled:false
                  },                         
                  series: [{
                      name: 'Total',
                      colorByPoint: true,
                      data: pieArr,                           
                  }]
              });
         });
        $A.enqueueAction(action);
    },         
    hideWaiting : function (component, event, helper) {
       component.set("v.toggleSpinner", false);    
    },
    showWaiting : function (component, event, helper) {
       component.set("v.toggleSpinner", true);
    },
})