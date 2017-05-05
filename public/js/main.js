$(document).ready(function() {
    // https://gist.github.com/flesler/3f3e1166690108abf747
    $('a[href^="#"],a[href^="/#"]').click(function(e) {
    	var url = new URL(document.URL);
    	if(url.pathname==this.pathname) {
            e.preventDefault();
            console.log(this, this.hash);
            $(window).stop(true).scrollTo(this.hash, {duration: 1000, interrupt: true});
        }
    });
    // initialize WOW animations
    new WOW().init();
    // process sections
    var sections = ['speaker'];
    $(sections).each(function(i){
		var section = this;
		var html = $("#"+section+"-template").html();
		var template   =  Handlebars.compile(html);
		$.getJSON("/data/"+section+".json").done(
			function(response){
				// check for success flag
				if(response && response.success) {
					var str = "";
					// process data entries
					$(response.data).each(function(i){
						// perform calculations, normalizations, etc.
						this._n = i;
						this._delay = 500*i;
						// process template
						str = str + template(this);
					});
					// output to #section-list
					$('#'+section+'-list').append(str);
				}
			}
		).fail(function( jqxhr, textStatus, error ) {
				var err = textStatus + ", " + error;
				console.log( "Request Failed for "+section+": " + err );
		});
	});
});