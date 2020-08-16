using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using backendPoSlojevima.DAL.Interfaces;
using backendPoSlojevima.Data;
using backendPoSlojevima.Models;

namespace backendPoSlojevima.DAL
{
    public class GradDAL : IGradDAL
    {
        private readonly ApplicationDbContext _contex;

        public GradDAL(ApplicationDbContext context)
        {
            _contex = context;
        }

        public List<Grad> getAllGradove()
        {
            return _contex.grad.ToList();
        }

        public int proveraIdGrada(long idGrada)
        {
           var check = _contex.grad.SingleOrDefault(g => g.id == idGrada);
                if (check != null)
                {
                    return 1;
                }
                return 0;
        }
    }
}