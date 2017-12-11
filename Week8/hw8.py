from azure.storage.queue import QueueService
from time import sleep

AZ_ACC_ID = "umairsa"
AZ_ACC_KEY = 'IYQ3DixIJjZao6jdnfizSyc0/fCRSArQUG8HmHI3jYKrq1/9YcQi3dM8cY4r+cJkiIdLX2ugB7DJ4be9OO22hA=='

queue_service = QueueService(account_name=AZ_ACC_ID, account_key=AZ_ACC_KEY)
print("Created a storage queue named: umairqueue \n")
queue_service.create_queue('umairqueue')

sleep(2)

print ("\n\n Publishing a series of 5 short messages to that queue... \n")
queue_service.put_message('umairqueue', u'#1 Message from Deep Azure Class!!')
queue_service.put_message('umairqueue', u'#2 Message from Deep Azure Class!!')
queue_service.put_message('umairqueue', u'#3 Message from Deep Azure Class!!')
queue_service.put_message('umairqueue', u'#4 Message from Deep Azure Class!!')
queue_service.put_message('umairqueue', u'#5 Message from Deep Azure Class!!')

print ("\n\nDe-queue two of those messages and print their content... \n")
messages = queue_service.get_messages('umairqueue', num_messages=2, visibility_timeout=10)
for message in messages:
    print(message.content)
    queue_service.delete_message('umairqueue', message.id, message.pop_receipt)

print("\n\nPeek into the next message.. \n")
messages = queue_service.peek_messages('umairqueue')
for messages in messages:
    print(messages.content)



print("\n\nUpdate the contents of the message to 'Updated Message NOW!!!' ")
print("and update the message visibility for 5 sec")
messages = queue_service.get_messages('umairqueue', num_messages=1, visibility_timeout=1)
for message in messages:
    queue_service.update_message('umairqueue', message.id, message.pop_receipt , 5,
                                 u'Updated Message NOW!!!')
    print("\n\nTry to dequeue that message right away. Report error or system message received.\n")
    try:
        queue_service.delete_message('umairqueue', message.id, message.pop_receipt)
    except:
        print ("\nMessage unable to be deleted")
        print("\n\nThen, wait 6 seconds, dequeue the message and print its content.\n")
        sleep(6)
    else:
        print("\n\nSuccessfully deleted message!\n")
    finally:
        messages = queue_service.get_messages('umairqueue', num_messages=1)
        for message in messages:
            print(message.content)
            queue_service.delete_message('umairqueue', message.id, message.pop_receipt)


input("\n\nLeave one message in the queue and do not delete the queue right away.\n Press any key to contine...")
metadata = queue_service.get_queue_metadata('umairqueue')
while (metadata.approximate_message_count > 1):
    messages = queue_service.get_messages('umairqueue', num_messages=1)
    for message in messages:
        print("Deleting message: " + message.content + '\n\n')
        queue_service.delete_message('umairqueue', message.id, message.pop_receipt)
    metadata = queue_service.get_queue_metadata('umairqueue')

message = queue_service.peek_messages('umairqueue')
print("Last message left in the queue: " + message[0].content + "\n\n")


input("Deleting queue, press any key to proceed?\n")

queue_service.delete_queue('umairqueue')

print("Queue deleted successfully!")