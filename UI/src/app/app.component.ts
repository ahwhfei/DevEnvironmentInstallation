import { Component, OnInit } from '@angular/core';

import { Application } from './application/application'
import { ApplicationService } from './application/application.service'

@Component({
    selector: 'app-root',
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.css'],
    providers: [ApplicationService]
})
export class AppComponent implements OnInit {
    applications: Application[];

    constructor(private applicationService: ApplicationService) {

    }

    getApplications(): void {
        this.applications = this.applicationService.getApplications();
    }

    ngOnInit(): void {
        this.getApplications();
    }
}
