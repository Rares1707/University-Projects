import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import {RoleSelectionComponent} from "./role-selection/role-selection.component";
import {FormsModule} from "@angular/forms";
import {CommonModule} from "@angular/common";

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    RouterOutlet,
    RoleSelectionComponent,
    FormsModule,
    CommonModule],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent {
  title = 'WebProgrammingLab8';
}
