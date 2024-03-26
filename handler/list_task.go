package handler

import (
	"net/http"

	"github.com/pdj107/go-todo-app/entity"
	"github.com/pdj107/go-todo-app/store"
)

type ListTask struct {
	Store *store.TaskStore
}

type task struct {
	ID     entity.TaskID     `json:"id"`
	Title  string            `json:"title"`
	Status entity.TaskStatus `json:"status"`
}

func (lt *ListTask) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	tasks := lt.Store.All()
	res := []task{}
	for _, t := range tasks {
		res = append(res, task{
			ID:     t.ID,
			Title:  t.Title,
			Status: t.Status,
		})
	}
	RespondJSON(ctx, w, res, http.StatusOK)
}