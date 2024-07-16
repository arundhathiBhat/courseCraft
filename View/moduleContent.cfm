<div class="container-fluid">
    <div class="row">
        <!-- Module List -->
        <div class="col-md-3 module-list">
            <h4>Modules</h4>
            <ul class="list-group">
                <!-- Dynamically populate the module list -->
                {{#each moduleDetails}}
                    <li class="list-group-item">
                        <input type="checkbox" id="module-{{this.moduleID}}" class="module-checkbox" disabled>
                        <label for="module-{{this.moduleID}}">
                            <a href="moduleContentPage.html?moduleID={{this.moduleID}}&moduleFile={{this.contentFilePath}}">{{this.moduleTitle}}</a>
                        </label>
                    </li>
                {{/each}}
            </ul>
        </div>
        <!-- PDF Viewer -->
        <div class="col-md-9 pdf-viewer">
            <iframe id="pdfViewerIframe" src="" width="100%" height="100%"></iframe>
        </div>
    </div>
</div>