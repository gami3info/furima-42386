const pay = () => {
  // 決済ページ以外では処理を実行しないようにする
  const form = document.getElementById('charge-form');
  if (!form) {
    return;
  }
  // gonが読み込まれていない、または公開鍵がない場合は処理を中断
  if (typeof gon === 'undefined' || !gon.public_key) {
    console.error('PAY.JP public key is not set.');
    return;
  }

  const publicKey = gon.public_key;
  const payjp = Payjp(publicKey);
  const elements = payjp.elements();

  const numberElement = elements.create('cardNumber');
  const expiryElement = elements.create('cardExpiry');
  const cvcElement = elements.create('cardCvc');

  numberElement.mount('#card-number');
  expiryElement.mount('#card-exp');
  cvcElement.mount('#card-cvc');

  form.addEventListener("submit", (e) => {
    e.preventDefault();
    const submitButton = form.querySelector('input[type="submit"]');
    submitButton.disabled = true; // 二重送信を防止

    payjp.createToken(numberElement).then(function (response) {
      if (response.error) {
        // エラーメッセージを表示する要素を取得
        const errorMessages = document.getElementById('error-message');
        if (errorMessages) {
          errorMessages.textContent = response.error.message;
        }
        // ボタンを有効に戻してフォームの送信を中止
        submitButton.disabled = false;
      } else {
        // 正常な場合はエラーメッセージをクリア
        const errorMessages = document.getElementById('error-message');
        if (errorMessages) {
          errorMessages.textContent = '';
        }

        const token = response.id;
        // 既存のトークンがあれば削除
        const existingToken = form.querySelector('input[name="token"]');
        if (existingToken) {
          existingToken.remove();
        }
        // 新しいトークンをフォームに追加
        const tokenInput = document.createElement("input");
        tokenInput.setAttribute("type", "hidden");
        tokenInput.setAttribute("name", "token");
        tokenInput.setAttribute("value", token);
        form.appendChild(tokenInput);

        // カード情報をクリアしてフォームを送信
        numberElement.clear();
        expiryElement.clear();
        cvcElement.clear();
        form.submit();
      }
    });
  });
};

window.addEventListener("turbo:load", pay);
window.addEventListener("turbo:render", pay);