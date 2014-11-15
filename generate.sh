#!/bin/sh

echo
echo "Get compiler..."
compiler="compiler-latest"
curl -sO http://dl.google.com/closure-compiler/$compiler.zip
unzip -o $compiler.zip -d $compiler

echo
echo "Get scriptaculous..."
scriptaculous="scriptaculous-js-1.9.0"
curl -sO http://script.aculo.us/dist/$scriptaculous.zip
unzip -o $scriptaculous.zip

echo
echo "Get prototypejs..."
prototype_ver="1.7.2.0"
if [ ! -d "prototypejs" ]; then mkdir prototypejs; fi
curl -so prototypejs/prototype.$prototype_ver.js https://ajax.googleapis.com/ajax/libs/prototype/$prototype_ver/prototype.js

echo
echo "Replace scriptaculous's functions to selectively load dependent scripts..."
perl -i.bak -pe 'BEGIN{undef $/;} s/require:.*REQUIRED_PROTOTYPE:/REQUIRED_PROTOTYPE:/gsm' $scriptaculous/src/scriptaculous.js
perl -i.bak.2 -pe 'BEGIN{undef $/;} s/\n    var js = .*    }\);//gsm' $scriptaculous/src/scriptaculous.js

echo
echo "Generate protoaculous.$prototype_ver.js and protoaculous.$prototype_ver.min.js in dist..."
cat prototypejs/prototype.$prototype_ver.js $scriptaculous/src/scriptaculous.js $scriptaculous/src/builder.js $scriptaculous/src/effects.js $scriptaculous/src/dragdrop.js $scriptaculous/src/controls.js $scriptaculous/src/slider.js $scriptaculous/src/sound.js > dist/protoaculous.$prototype_ver.js
java -jar compiler-latest/compiler.jar --js_output_file=dist/protoaculous.$prototype_ver.min.js dist/protoaculous.$prototype_ver.js

ls -al dist/