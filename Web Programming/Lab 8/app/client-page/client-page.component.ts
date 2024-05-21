import { Component } from '@angular/core';
import {RouterLink} from "@angular/router";
import {GuestbookServiceService} from "../guestbook-service.service";
import {FormsModule} from "@angular/forms";

@Component({
  selector: 'app-client-page',
  standalone: true,
  imports: [
    RouterLink,
    FormsModule
  ],
  templateUrl: './client-page.component.html',
  styleUrl: './client-page.component.css'
})
export class ClientPageComponent {
  service : GuestbookServiceService
  newAuthor : string = ''
  newTitle: string = '';
  newComment: string = '';
  constructor(service: GuestbookServiceService) {
    this.service = service
  }

  addRecord() {
    this.service.addRecord(this.newAuthor, this.newTitle, this.newComment)
      .subscribe(response => console.log(response))
  }
}
