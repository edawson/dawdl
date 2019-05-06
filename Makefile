
DOCKERFILES = $(wildcard *.Dockerfile)
BASE_REPO = erictdawson
PUSH_REPO = javelina
date = $(shell date +"%Y-%b-%d")

make_tags:
	mkdir -p make_tags

push: make_tags/$(APP).built make_tags

build: dockerfiles/$(APP).Dockerfile make_tags
	+docker build -t $(BASE_REPO)/$(APP) -f dockerfiles/$(APP).Dockerfile . && touch make_tags/$(APP).built
	+docker tag $(BASE_REPO)/$(APP) $(BASE_REPO)/$(APP):latest
	+docker tag $(BASE_REPO)/$(APP) $(BASE_REPO)/$(APP):$(date)

push: build  make_tags
	+docker push $(BASE_REPO)/$(APP):latest && touch make_tags/$(APP).latest
	+docker push $(BASE_REPO)/$(APP):$(date) && touch make_tags/$(APP).$(date)
	#+docker push $(PUSH_REPO)/$(APP):latest && touch make_tags/$(APP).latest
	#+docker push $(PUSH_REPO)/$(APP):$(date) && touch make_tags/$(APP).$(date)

clean:
	$(RM) make_tags

.PHONY: build push clean
