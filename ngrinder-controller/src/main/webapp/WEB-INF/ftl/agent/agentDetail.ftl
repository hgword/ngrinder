<!DOCTYPE html>
<html>
    <head>
       	<#include "../common/common.ftl">
       	<#include "../common/jqplot.ftl">
        <title><@spring.message "agent.info.title"/></title>
       	<style>
            .left { border-right: 1px solid #878988 }
            div.chart { border: 1px solid #878988; height:250px; min-width:615px; margin-bottom:12px; padding: 5px }
            .jqplot-yaxis {
			    margin-right: 10px; 
			}
			
			.jqplot-xaxis {
			    margin-top: 5px; 
			} 
        </style>
    </head>

    <body>
        <#include "../common/navigator.ftl">
        <div class="container">
            <div class="page-header pageHeader" style="margin-bottom: 10px">
				<h3><@spring.message "agent.info.head"/></h3>
			</div>
			<button onClick="window.history.back();" class="btn pull-right" style="margin-top:-45px;"><@spring.message "common.button.return"/></button>
            <div class="row">
                <div class="span3">
                    <table class="table table-bordered table-striped" style="border-top:#cccccc solid 1px">
				    <tbody>
					    <tr>
					    	<th><@spring.message "agent.table.IP"/></th>
					    </tr>
	                    <tr>
					    	<td>${(agent.ip)!}</td>
					    </tr>
					    <tr>
					    	<th><@spring.message "agent.table.port"/></th>
					    </tr>
	                    <tr>
					    	<td>${(agent.port)!}</td>
					    </tr>
					    <tr>
					    	<th><@spring.message "agent.table.name"/></th>
					    </tr>
	                    <tr>
					   		<td>${(agent.hostName)!}</td>
					    </tr>
					    	<th><@spring.message "agent.table.region"/></th>
					    </tr>
	                    <tr>
					    	<td>${(agent.region)!}</td>
					    </tr>
					    </tr>
					    <tr>
					    	<th><@spring.message "agent.table.status"/></th>
					    </tr>
	                    <tr>
					    	<td>${(agent.status)!}</td>
					    </tr>
				    </tbody>
				    </table>
				    <label><@spring.message "agent.info.refreshInterval"/></label>
                    <input id="rinterval" type="text" class="span3" placeholder="number" value="1">
                </div>
                <div class="span9">
					<div class="tabbable" style="margin-left:20px">
                        <ul class="nav nav-tabs" id="chartTab">
                            <li><a href="#systemData" data-toggle="tab"><@spring.message "agent.info.systemData"/></a></li>
                        </ul>
                        <div class="tab-content">
                            <div class="tab-pane active" id="systemData">
								<div class="page-header">
									<h4>CPU</h4>
								</div>
                                <div class="chart" id="cpuDiv"></div>
								<div class="page-header">
									<h4>Used Memory</h4>
								</div>
                                <div class="chart" id="memoryDiv"></div>
                            </div>
					     </div>
                    </div>
                </div>
            </div>
        	<#include "../common/copyright.ftl">
    	<!--content-->
        </div>
        <script src="${req.getContextPath()}/js/queue.js?${nGrinderVersion}"></script>
        <script>
            var interval;
            var timer;
			var sys_totalCpuValue = new Queue();
			var sys_usedMemory = new Queue();
			initChartData();
			var jqplots = [];
            $(document).ready(function() {
            	$("#chartTab a:first").tab('show');
            	
                $("#returnBtn").on('click', function() {
                    history.back();
                });
                
                $("#rinterval").keyup(function() {
                    var number = $(this).val();
                    $(this).val(number.replace(/[\D]/g,""))
                });
                
                $("#rinterval").blur(function() {
                    if(timer){
                        window.clearInterval(timer);
                    }
                    interval = $(this).val();
                    if(interval == 0){
                        interval = 1;
                    }
                    cleanChartData();
                    timer=window.setInterval("getMonitorData()",interval * 1000);
                });
                
                $('#chartTab a').click(function () {
					resetFooter();
				});
				
                getMonitorData();
                $("#rinterval").blur();
            });
            var maxCPU = 0;
            var maxMemory = 0;
            
            function getMax(prev, current) {
            	var currentMax = 0;
            	for (var i = 0; current.length > i; i++) {
	            	if (current[i] > currentMax) {
	            		currentMax = current[i];
	            	}
            	}
            	if (prev > currentMax) {
            		return prev;
            	}
            	return currentMax;
            }
            function getMonitorData(){
                $.ajax({
                    url: "${req.getContextPath()}/agent/systemDataModel",
                    async: false,
					cache: false,
                    dataType:'json',
                    data: {'id': '${(agent.id)!}',
                    	   'ip': '${(agent.ip)!}',
                    	   'name': '${(agent.hostName)!}',
                           'imgWidth':700},
                    success: function(res) {
                        if (res.success) {
                        	getChartData(res);
                        	if ($("#chartTab li:first").hasClass("active")) {
                        		maxCPU = getMax(maxCPU, sys_totalCpuValue.aElement);
                        		showChart('CPU', 'cpuDiv', sys_totalCpuValue.aElement, 0, formatPercentage, maxCPU);
                        		maxMemory = getMax(maxMemory, sys_usedMemory.aElement);
                            	showChart('Used Memory', 'memoryDiv', sys_usedMemory.aElement, 1, formatMemory, maxMemory);
                        	} else {
                        		
                        	}
                            return true;
                        } else {
                            showErrorMsg("Get monitor data failed.");
                            return false;
                        }
                    },
                    error: function() {
                        showErrorMsg("Error!");
                        
                        return false;
                    }
                });
            }
            
            function showChart(title, id, data, index, formatYaxis, maxY) {
				var pt = jqplots[index];
            	if (pt) {
            		replotChart(pt, data, maxY, $("#rinterval").val());
            	} else {
	                jqplots[index] = drawChart(title, id, data, formatYaxis);
            	}
            }
            
            function initChartData() {
                for (var i = 0; i < 60; i++) {
		        	sys_totalCpuValue.enQueue(0);
		        	sys_usedMemory.enQueue(0);
            	}	
            }
            
            function getChartData(dataObj) {				
				sys_totalCpuValue.enQueue(dataObj.systemData.cpuUsedPercentage);
				sys_usedMemory.enQueue(dataObj.systemData.totalMemory - dataObj.systemData.freeMemory);
				
				if (sys_totalCpuValue.getSize() > 60) {
					sys_totalCpuValue.deQueue();
					sys_usedMemory.deQueue();
				}
			}
			
			function cleanChartData() {
				sys_totalCpuValue.makeEmpty();
				sys_usedMemory.makeEmpty();
				initChartData();
			}
        </script>
    </body>
</html>