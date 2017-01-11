import { Injectable } from '@angular/core'

import { Application } from './application'
import { APPLICATIONS } from './mock-applications'

@Injectable()
export class ApplicationService {
    getApplications(): Application[] {
        return APPLICATIONS;
    }
}