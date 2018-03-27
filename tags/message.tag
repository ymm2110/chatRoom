<message>

<<<<<<< HEAD
	<span>{ msg.name + ": " +msg.message + "   -- " + msg.time}</span>
=======
	<span>{ msg.name + ": " +msg.message }</span><i class="fa fa-trash-o trash" onclick={delete}></i>
>>>>>>> 699527c24e43f1d1d107ec50f9310c8ef389f6d0

	<script>
		var that = this;
		console.log('message.tag');
		this.delete = function(e) {
			console.log(e.item)
			messagesRef.child(e.item.msg.id).remove();
		}









	</script>

	<style>
		:scope {
			display: block;
			border: 1px solid dodgerblue;
			padding: 0.5em;
		}
		:scope:not(:last-child) {
			margin-bottom: 1em;
		}

		.trash {
			margin-left: 10px;
			cursor: pointer;
		}

	</style>
</message>
