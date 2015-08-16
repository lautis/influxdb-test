//= require jquery
//= require d3
//= require metrics-graphics
//= require fetch
//= require select2

function fetchOrigin(origin) {
  return fetch('/api/1/pings/' + origin + '/hours')
    .then(function(response) { return response.json()})
}

function showOrigin(origin) {
  fetchOrigin(origin).then(function(pings) {
    MG.data_graphic({
      title: 'Mean Transfer Time for ' + origin,
      data: pings.map(function(ping) {
        return {
          time: new Date(ping['time']),
          mean_transfer_time_ms: ping['mean_transfer_time_ms'],
          label: ping['mean_transfer_time_ms'].toFixed(2) + ' ms'
        }
      }),
      animate_on_load: true,
      y_extended_ticks: false,
      width: 600,
      height: 250,
      left: 75,
      target: '#chart',
      x_accessor: 'time',
      y_accessor: 'mean_transfer_time_ms',
      yax_format: function(ms) { return ms + ' ms'; }
    });
  });
}

$(function() {
  showOrigin($('#origin').val());
  $('#origin').select2()
    .focus(function () { $(this).select2('open'); })
    .on('change', function() {
      showOrigin($(this).val());
    });
});
