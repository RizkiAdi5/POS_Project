(function () {
  'use strict';

  function initEmenuSalesCharts() {
    var data = window.EMENU_SALES_DATA;
    if (!data || typeof Chart === 'undefined') return;

    var currencySymbol = data.currencySymbol || '';
    var decimals = Number.isFinite(data.currencyDecimals) ? data.currencyDecimals : 2;
    var charts = [];

    function formatMoney(value) {
      var n = Number(value) || 0;
      return currencySymbol + ' ' + n.toLocaleString('en-US', {
        minimumFractionDigits: decimals,
        maximumFractionDigits: decimals
      });
    }

    var palette = ['#F97316', '#3B82F6', '#8B5CF6', '#22C55E', '#EC4899', '#14B8A6', '#EAB308'];

    var trendCanvas = document.getElementById('emenuRevenueTrendChart');
    if (trendCanvas) {
      charts.push(new Chart(trendCanvas, {
        type: 'line',
        data: {
          labels: data.trendLabels || [],
          datasets: [{
            label: 'Revenue',
            data: data.trendValues || [],
            borderColor: '#F97316',
            backgroundColor: 'rgba(249, 115, 22, 0.12)',
            borderWidth: 2.5,
            pointBackgroundColor: '#F97316',
            pointBorderColor: '#fff',
            pointBorderWidth: 2,
            pointRadius: 4,
            pointHoverRadius: 5,
            fill: true,
            tension: 0.35
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: { display: false },
            tooltip: {
              callbacks: {
                label: function (ctx) {
                  return ' ' + formatMoney(ctx.parsed.y);
                }
              }
            }
          },
          scales: {
            x: {
              grid: { display: false },
              ticks: { color: '#6b7280', font: { size: 12 }, maxRotation: 0 }
            },
            y: {
              beginAtZero: true,
              grid: { color: '#f3f4f6' },
              ticks: {
                color: '#6b7280',
                font: { size: 12 },
                callback: function (value) {
                  return formatMoney(value);
                }
              }
            }
          }
        }
      }));
    }

    var pieCanvas = document.getElementById('emenuCategoryPieChart');
    if (pieCanvas) {
      var catLabels = data.categoryLabels || [];
      var catValues = data.categoryValues || [];
      var total = catValues.reduce(function (sum, v) { return sum + (Number(v) || 0); }, 0);

      charts.push(new Chart(pieCanvas, {
        type: 'pie',
        data: {
          labels: catLabels,
          datasets: [{
            data: catValues,
            backgroundColor: catLabels.map(function (_, i) { return palette[i % palette.length]; }),
            borderWidth: 2,
            borderColor: '#fff'
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              position: 'right',
              labels: {
                boxWidth: 12,
                boxHeight: 12,
                color: '#374151',
                font: { size: 12 },
                generateLabels: function (chart) {
                  var ds = chart.data.datasets[0];
                  return chart.data.labels.map(function (label, i) {
                    var val = Number(ds.data[i]) || 0;
                    var pct = total > 0 ? Math.round((val / total) * 100) : 0;
                    return {
                      text: label + '  ' + pct + '%',
                      fillStyle: ds.backgroundColor[i],
                      strokeStyle: '#fff',
                      lineWidth: 1,
                      hidden: false,
                      index: i
                    };
                  });
                }
              }
            },
            tooltip: {
              callbacks: {
                label: function (ctx) {
                  var val = Number(ctx.parsed) || 0;
                  var pct = total > 0 ? Math.round((val / total) * 100) : 0;
                  return ' ' + ctx.label + ': ' + formatMoney(val) + ' (' + pct + '%)';
                }
              }
            }
          }
        }
      }));
    }

    function resizeCharts() {
      charts.forEach(function (chart) {
        if (chart && typeof chart.resize === 'function') {
          chart.resize();
        }
      });
    }

    if (window.addEventListener) {
      window.addEventListener('resize', resizeCharts);
    }
    setTimeout(resizeCharts, 100);
    setTimeout(resizeCharts, 400);
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initEmenuSalesCharts);
  } else {
    initEmenuSalesCharts();
  }
})();
