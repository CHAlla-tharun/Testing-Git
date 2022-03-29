import { createElement } from "lwc";
import searchAccountName from "c/SearchAccountName";
import { getAccountList } from "lightning/uiRecordApi";

// Import mock data to send through the wire adapter.
const mockGetRecord = require("./data/getAccountList.json");
test("c-SearchAccountName", () => {
  const element = createElement("c-SearchAccountName", 
  { is: searchAccountName
   });
  document.body.appendChild(element);
  // Emit mock record into the wired field
  getAccountList.emit(mockGetRecord);
  // Resolve a promise to wait for a rerender of the new content.
  return Promise.resolve().then(() => {
    const content = element.shadowRoot.querySelector(".content");
    const accountName = mockGetRecord.fields.Name.value;
    expect(content.textContent).toBe(`Name:${accountName}`);
  });
});