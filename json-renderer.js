const fs = require("fs");
const jsonfile = require('jsonfile');
const jsonld = require('jsonld');
const jp = require('jsonpath');
const camelCase = require('camelcase');
const papaparse = require('papaparse');

 
var program = require('commander');
 
program
  .version('0.8.0')
  .usage('node json-renderer.js renders the content of a json file into a jsonld template')
  .option('-t, --template <template>', 'jsonld template to render')
  .option('-h, --contextbase <hostname>', 'the public base url on which the context of the jsons are published.')
  .option('-r, --documentpath <path>', 'the document path on which the jsons are is published')
  .option('-x, --debug <path>', 'dump the intermediate json which will be used by the templaterenderer')
  .option('-l, --list <list>', 'the list on which the data must iterate')
  .option('-i, --input <path>', 'input file (a csv file)')
  .option('-o, --output <path>', 'output file (a json file)')

program.on('--help', function(){
  console.log('')
  console.log('Examples:');
  console.log('  $ json-renderer --help');
  console.log('  $ json-renderer -t <template> -i <input> -o <output>');
});

program.parse(process.argv);

var output = program.output || 'output.json';
var jsonoptions = {
	header: true,
	skipEmptyLines: true,
	complete: function(results) {
		console.log("Finished:");
	}
	}


render_json(program.template, program.input, output);
console.log('done');



function render_json(templatefile, jsonfilename, output) {
  console.log('start reading');
  var template = fs.readFileSync(templatefile, 'utf-8');
  var jsonf = fs.readFileSync(jsonfilename, 'utf-8');
  var json = JSON.parse(jsonf, jsonoptions);

  var pt = parse_template(template);
//  var ren = render_template(pt, {'ID':'een identifier', 'STRING' : 'een string waarde', 'BOOLEAN': 'true', 'VAL' : 'I do not know'});
  var ren = render_template(pt, json);
//  console.log(ren);

/*
  jsonfile.writeFile(output, ren, function (err) {
		if (err) {
		   // Set the exit code if there's a problem so bash sees it
		   process.exitCode = 1;
                   console.error(err);
                   throw err;
                   }
		});
*/

  let writeStream = fs.createWriteStream(output);

write_data(writeStream, ren);	
  writeStream.on('finish', () => {
	      console.log('wrote all data to file');
  });

	// close the stream
   writeStream.end();
	
	console.log('finished rendering to ' + output);
};



	


function parse_template(file) {
	var parsed_template = {
		pt_full: [],
		pt_vars :[]
	};
	
	var file1 = file.split('{{');
	var file2 = [];
	for (i in file1) {
	   file2 = file2.concat(file1[i].split('}}'));
	};
	parsed_template.pt_full = file2;
	
	return parsed_template
}

function render_template(parsed_template, json){
	var renderedData = [];
        var data = jp.query(json,program.list);
	for (i in data) {
	  renderedData[i] = render_template_single(parsed_template,data[i]);
	}
	return renderedData;
};

function render_template_single(parsed_template, data){
	let render = '';
	for (i in parsed_template.pt_full) {
	  let reminder = i % 2;
	  if (reminder == 0) {
		render = render + parsed_template.pt_full[i];
	  } else {
	console.log(parsed_template.pt_full[i]);
               let value = jp.query(data, parsed_template.pt_full[i]);
        console.log(value);
               render = render + value;
			
	  }
	}
	return render;
}

function write_data(stream, data){
        stream.write("[");
	for (i in data) {
	  stream.write(data[i]);
          stream.write(",")
	}
        stream.write("]");
	return true;
};

