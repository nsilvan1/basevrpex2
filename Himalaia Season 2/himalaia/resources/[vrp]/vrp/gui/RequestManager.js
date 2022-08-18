function RequestManager() {
	var _this = this;
	setInterval(function () { _this.tick(); }, 1000);
	this.requests = []
	this.div = document.createElement("div");
	this.div.classList.add("requestManager");
	document.body.appendChild(this.div);
}

RequestManager.prototype.buildText = function (text, time) {
	return "<div class='main'><div id='NotifyBackground'><div class='interno'><div class='alert-logo'><img src='sinos.png' alt=''></div><div class='flex-container'><div class='texto'>" + text + "</div><div class='buttons'><div class='aceitar'><green>Y</green></div><div class='recusar'><red>U</red></div></div></div></div></div>";
}

RequestManager.prototype.addRequest = function (id, text, time) {
	var request = {}
	request.div = document.createElement("div");
	request.id = id;
	request.time = time - 1;
	request.text = text;
	request.div.innerHTML = this.buildText(text, time - 1);
	this.requests.push(request);
	this.div.appendChild(request.div);
}

RequestManager.prototype.respond = function (ok) {
	if (this.requests.length > 0) {
		var request = this.requests[0];
		if (this.onResponse)
			this.onResponse(request.id, ok);
		this.div.removeChild(request.div);
		this.requests.splice(0, 1);
	}
}

RequestManager.prototype.tick = function () {
	for (var i = this.requests.length - 1; i >= 0; i--) {
		var request = this.requests[i];
		request.time -= 1;
		request.div.innerHTML = this.buildText(request.text, request.time, request.id);
		if (request.time <= 0) {
			this.div.removeChild(request.div);
			this.requests.splice(i, 1);
		}
	}
}