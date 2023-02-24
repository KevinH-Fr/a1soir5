# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

pin "trix"
pin "@rails/actiontext", to: "actiontext.js"

pin "@zxing/browser", to: "https://ga.jspm.io/npm:@zxing/browser@0.1.1/esm/index.js"
pin "@zxing/library", to: "https://ga.jspm.io/npm:@zxing/library@0.19.2/esm/index.js"
pin "ts-custom-error", to: "https://ga.jspm.io/npm:ts-custom-error@3.3.1/dist/custom-error.mjs"

pin "chart"