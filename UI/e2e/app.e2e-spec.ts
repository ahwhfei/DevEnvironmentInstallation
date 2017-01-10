import { UIPage } from './app.po';

describe('ui App', function() {
  let page: UIPage;

  beforeEach(() => {
    page = new UIPage();
  });

  it('should display message saying app works', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('app works!');
  });
});
