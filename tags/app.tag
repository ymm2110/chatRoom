<app>

	<div class="container-fluid">
		<div class="row">
			<div class="col-10 offset-1">
				<h1>MSTU Chatroom</h1>
			</div>
		</div>

		<div class="row">
			<div class="col-8 offset-2 name">
				<input type="text" ref="userName" placeholder="Type Your Name Here">
				<button type="button" onclick={ setName }>Submit</button>
			</div>
		</div>

		<div class="row">
			<div class="col-8 offset-2 name">
				<input type="text" ref="chatRoomName" placeholder="Type A Topic Here to Start a New Chatroom">
				<button type="button" onclick={ setTopic }>Start</button>

			</div>
		</div>


		<div class="row">
			<div class="col-4 offset-4">
				<div class="chatLog" ref="chatLog">
					<message each={ msg in chatLog }></message>
				</div>
				<input type="text" ref="messageInput" onkeypress={ sendMsg } placeholder="Enter Message">
				<button type="button" onclick={ sendMsg }  >Send</button>
			</div>
		</div>
	</div>

	<script>
		var that = this;
		this.userName = "";
		this.chatRoomName = "messages";

		setName(){
			if (this.refs.userName.value == ""){
				alert("Please type your name in the box");
			} else {
				userName = this.refs.userName.value;
			}
		}

		setTopic(){
			if (this.refs.chatRoomName.value !== ""){
				chatRoomName = this.refs.chatRoomName.value;
				messagesRef = database.ref(chatRoomName);
				console.log(messagesRef);
			}
		}

		// Global Cached references See index.html for var database, messagesRef Demonstration Data
		this.chatLog = []; // Empty Data

			messagesRef.on('child_added', function(snapshot) {
				console.log(snapshot.key);
				var id = snapshot.key;
				var data = snapshot.val();
				data.id = id;
				that.chatLog.push(data);
				that.update();
			})

			messagesRef.on('child_removed', function(snapshot) {
				var id = snapshot.key;

				var target;
				for (let i = 0; i < that.chatLog.length; i++) {
					if (that.chatLog[i].id === id) {
						target = that.chatLog[i];
						break
					}
				}
				var index = that.chatLog.indexOf(target);
				that.chatLog.splice(index, 1);

				that.update();
			})



		sendMsg(e) {
			if (e.type == "keypress" && e.key !== "Enter") {
				e.preventUpdate = true; // Prevents riot from auto update.
				return false; // Short-circuits function (function exits here, does not continue.)
			}

			// check if user name is logged.
			if (userName === "") {
				alert("Please type your name in the box");
				this.clearInput();
				return false;
			}




			var msg = {
				message: this.refs.messageInput.value,
				userName: userName,
			};

			var messageTime = moment().format('lll');
			msg.messageTime = messageTime;
			console.log(msg.messageTime);



			/***
				We no longer need to push data directly into our array on the client-side when we create a message object.
				The source of the state of this tag (chatLog) is with Firebase.
				Our firebase listener links our chatLog list directly to the database. That becomes the source
				of the state of this tag. The chatLog list is merely a reactionary reflection of that truth data.

				this.chatLog.push(msg); // Prior code that pushed msg data directly to the chatLog array
			***/

			messagesRef.push(msg);
			// Notice the difference between messagesRef.push() vs. this.chatLog.push(); Here, we are using the Firebase push() to push to the database reference. With that.chatLog.push() we are using the JS Array push() to push directly to the array.

			/***
				Also notice that we do not that.update() here. All we do is change the state of data on our database.
				Our listener to the database above, is what will react to the changes on our database, then sync our chatLog
				to the data in our database, then kick-off manually that.update() of this riot tag.
			***/

			this.clearInput();
		}

		clearInput(e) {
			this.refs.messageInput.value = "";
			this.refs.messageInput.focus();
		}
	</script>

	<style>
		:scope {
			display: block;
			padding: 10px;
			font-family: monospace;
			font-size: 1.3em;
		}

		h1 {
			text-align: center;
			text-transform: uppercase;
			color: white;
			border: 2px solid #4A225D;
			background-color: #4A225D;
			border-radius: 5px;
			padding: 10px;
		}

		.name {
			text-align: center;
			padding: 10px;
		}

		.chatLog {
			border: 1px solid grey;
			padding: 1em;
			margin-bottom: 1em;
		}

		[ref="messageInput"],
		button {
			font-size: 1em;
			padding: 0.5em;
		}

		[ref="messageInput"] {
			width: 50%;
		}
	</style>
</app>
