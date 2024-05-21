import { Routes } from '@angular/router';
import {RoleSelectionComponent} from "./role-selection/role-selection.component";
import {ClientPageComponent} from "./client-page/client-page.component";
import {AdministratorPageComponent} from "./administrator-page/administrator-page.component";
import {AppComponent} from "./app.component";

export const routes: Routes = [
  { path: '', redirectTo: 'role-selection', pathMatch: 'full' },
  { path: 'role-selection', component: RoleSelectionComponent },
  { path: 'client-page', component: ClientPageComponent },
  { path: 'administrator-page', component: AdministratorPageComponent }
];
